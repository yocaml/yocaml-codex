module Projection
    (Set : Stdlib.Set.S)
    (C : Sigs.COMPARABLE with type t = Set.elt)
    (S : Yocaml.Data.S with type t = C.t) =
struct
  let to_data =
    Enumerable.to_data
      ~kind:"set"
      ~cardinal:Set.cardinal
      ~is_empty:Set.is_empty
      (fun set -> set |> Set.to_list |> Yocaml.Data.list_of S.to_data)
  ;;
end

module Validation
    (Set : Stdlib.Set.S)
    (C : Sigs.COMPARABLE with type t = Set.elt)
    (S : Yocaml.Data.Validation.S with type t = C.t) =
struct
  let from_data = Enumerable.from_data ~from_list:Set.of_list S.from_data
end

module Projectable (C : Sigs.COMPARABLE) (S : Yocaml.Data.S with type t = C.t) =
struct
  module Set = Stdlib.Set.Make (C)
  include Set
  include Projection (Set) (C) (S)
end

module Validable
    (C : Sigs.COMPARABLE)
    (S : Yocaml.Data.Validation.S with type t = C.t) =
struct
  module Set = Stdlib.Set.Make (C)
  include Set
  include Validation (Set) (C) (S)
end

module Make
    (C : Sigs.COMPARABLE)
    (P : Yocaml.Data.S with type t = C.t)
    (V : Yocaml.Data.Validation.S with type t = C.t) =
struct
  module Set = Stdlib.Set.Make (C)
  include Set
  include Projection (Set) (C) (P)
  include Validation (Set) (C) (V)
end
