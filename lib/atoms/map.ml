module Projection
    (Map : Stdlib.Map.S)
    (C : Sigs.COMPARABLE with type t = Map.key)
    (S : Yocaml.Data.S with type t = C.t) =
struct
  let to_data f =
    Enumerable.to_data
      ~kind:"map"
      ~cardinal:Map.cardinal
      ~is_empty:Map.is_empty
      (fun map ->
         let open Yocaml.Data in
         map
         |> Map.to_list
         |> list_of (fun (k, v) -> record [ "key", S.to_data k; "value", f v ]))
  ;;
end

module Validation
    (Map : Stdlib.Map.S)
    (C : Sigs.COMPARABLE with type t = Map.key)
    (S : Yocaml.Data.Validation.S with type t = C.t) =
struct
  let validate_line f =
    let open Yocaml.Data.Validation in
    ((function
       | Yocaml.Data.List [ a; b ] ->
         Ok (Yocaml.Data.record [ "fst", a; "snd", b ])
       | x -> Ok x)
     & pair S.from_data f)
    / record (fun o ->
      let+ key =
        field o.${"key"} (option S.from_data)
        |? field o.${"k"} (option S.from_data)
        |? field o.${"index"} (option S.from_data)
        |? field o.${"i"} (option S.from_data)
        |? field o.${"fst"} (option S.from_data)
        |? field o.${"first"} (option S.from_data)
        $? field o.${"0"} S.from_data
      and+ value =
        field o.${"value"} (option f)
        |? field o.${"val"} (option f)
        |? field o.${"v"} (option f)
        |? field o.${"snd"} (option f)
        |? field o.${"second"} (option f)
        $? field o.${"1"} f
      in
      key, value)
  ;;

  let from_data f =
    Enumerable.from_data ~from_list:Map.of_list (validate_line f)
  ;;
end

module Projectable (C : Sigs.COMPARABLE) (S : Yocaml.Data.S with type t = C.t) =
struct
  module Map = Stdlib.Map.Make (C)
  include Map
  include Projection (Map) (C) (S)
end

module Validable
    (C : Sigs.COMPARABLE)
    (S : Yocaml.Data.Validation.S with type t = C.t) =
struct
  module Map = Stdlib.Map.Make (C)
  include Map
  include Validation (Map) (C) (S)
end

module Make
    (C : Sigs.COMPARABLE)
    (P : Yocaml.Data.S with type t = C.t)
    (V : Yocaml.Data.Validation.S with type t = C.t) =
struct
  module Map = Stdlib.Map.Make (C)
  include Map
  include Projection (Map) (C) (P)
  include Validation (Map) (C) (V)
end

module String = Make (Orderable.String) (Orderable.String) (Orderable.String)
