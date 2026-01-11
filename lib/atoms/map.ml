module Projectable
    (Map : Stdlib.Map.S)
    (S : Yocaml.Data.S with type t = Map.key) =
struct
  type 'a t = 'a Map.t

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

module Validable
    (Map : Stdlib.Map.S)
    (S : Yocaml.Data.Validation.S with type t = Map.key) =
struct
  type 'a t = 'a Map.t

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

module Make
    (Map : Stdlib.Map.S)
    (P : Yocaml.Data.S with type t = Map.key)
    (V : Yocaml.Data.Validation.S with type t = Map.key) =
struct
  include Projectable (Map) (P)
  include Validable (Map) (V)
end

module String = struct
  module Map = Stdlib.Map.Make (Stdlib.String)
  include Map
  include Make (Map) (Orderable.String) (Orderable.String)
end

module Datetime = struct
  module Map = Stdlib.Map.Make (Orderable.Datetime)
  include Map
  include Make (Map) (Orderable.Datetime) (Orderable.Datetime)
end

module Path = struct
  include Yocaml.Path.Map
  include Make (Yocaml.Path.Map) (Orderable.Path) (Orderable.Path)
end
