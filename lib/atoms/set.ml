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

  type elt = Set.elt

  module Zero_or_more = struct
    type t =
      { main : P.t option
      ; other : Set.t
      }

    let empty = { main = None; other = Set.empty }

    let from_list = function
      | [] -> empty
      | x :: xs ->
        let main = Some x in
        let other = xs |> Set.of_list |> Set.remove x in
        { main; other }
    ;;

    let main { main; _ } = main
    let other { other; _ } = other
    let all { main; other } = Ext.Option.may_perform Set.add other main

    let from_data =
      let open Yocaml.Data.Validation in
      list_of V.from_data $ from_list
    ;;

    let to_data ({ main; other } as x) =
      let open Yocaml.Data in
      record
        [ "main", option P.to_data main
        ; "has_main", bool @@ Ext.Option.to_bool main
        ; "other", to_data other
        ; "all", to_data (all x)
        ]
    ;;
  end
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

let collapse_with_option
      (type a b)
      (module S : Stdlib.Set.S with type elt = a and type t = b)
      all
      opt_one
  =
  let open Ext.Option in
  let main = opt_one <|> S.find_first_opt (fun _ -> true) all in
  let rest = may_perform S.remove all main in
  let all = may_perform S.add rest main in
  main, rest, all
;;
