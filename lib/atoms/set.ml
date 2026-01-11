module Projectable
    (Set : Stdlib.Set.S)
    (S : Yocaml.Data.S with type t = Set.elt) =
struct
  type t = Set.t

  let to_data =
    Enumerable.to_data
      ~kind:"set"
      ~cardinal:Set.cardinal
      ~is_empty:Set.is_empty
      (fun set -> set |> Set.to_list |> Yocaml.Data.list_of S.to_data)
  ;;
end

module Validable
    (Set : Stdlib.Set.S)
    (S : Yocaml.Data.Validation.S with type t = Set.elt) =
struct
  type t = Set.t

  let from_data = Enumerable.from_data ~from_list:Set.of_list S.from_data
end

module Make
    (Set : Stdlib.Set.S)
    (P : Yocaml.Data.S with type t = Set.elt)
    (V : Yocaml.Data.Validation.S with type t = Set.elt) =
struct
  include Projectable (Set) (P)
  include Validable (Set) (V)
end

module String = struct
  module Set = Stdlib.Set.Make (Stdlib.String)
  include Set
  include Make (Set) (Orderable.String) (Orderable.String)
end

module Datetime = struct
  module Set = Stdlib.Set.Make (Orderable.Datetime)
  include Set
  include Make (Set) (Orderable.Datetime) (Orderable.Datetime)
end

module Path = struct
  include Yocaml.Path.Set
  include Make (Yocaml.Path.Set) (Orderable.Path) (Orderable.Path)
end
