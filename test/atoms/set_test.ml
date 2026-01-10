open Codex_atoms
open Test_util
module SP = Set.Make (Person) (Person) (Person)

let%expect_test "normalize an empty set" =
  SP.empty |> dump_data SP.to_data;
  [%expect
    {|
    {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
    "elements": []}
    |}]
;;

let%expect_test "normalize a set" =
  [ Person.make "a"; Person.make "b" ] |> SP.of_list |> dump_data SP.to_data;
  [%expect
    {|
    {"kind": "set", "length": 2, "is_empty": false, "is_not_empty": true,
    "elements":
     [{"display_name": "a", "first_name": null, "last_name": null},
     {"display_name": "b", "first_name": null, "last_name": null}]}
    |}]
;;

let%expect_test "validate from an empty list" =
  []
  |> Yocaml.Data.list_of Person.to_data
  |> SP.from_data
  |> dump_validation SP.to_data;
  [%expect
    {|
    [V]	{"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
        "elements": []}
    |}]
;;

let%expect_test "validate from a list" =
  [ Person.make "a"; Person.make "b" ]
  |> Yocaml.Data.list_of Person.to_data
  |> SP.from_data
  |> dump_validation SP.to_data;
  [%expect
    {|
    [V]	{"kind": "set", "length": 2, "is_empty": false, "is_not_empty": true,
        "elements":
         [{"display_name": "a", "first_name": null, "last_name": null},
         {"display_name": "b", "first_name": null, "last_name": null}]}
    |}]
;;

let%expect_test "validate from a record - all" =
  Yocaml.Data.record
    [ ( "all"
      , [ Person.make "a"; Person.make "b" ]
        |> Yocaml.Data.list_of Person.to_data )
    ]
  |> SP.from_data
  |> dump_validation SP.to_data;
  [%expect
    {|
    [V]	{"kind": "set", "length": 2, "is_empty": false, "is_not_empty": true,
        "elements":
         [{"display_name": "a", "first_name": null, "last_name": null},
         {"display_name": "b", "first_name": null, "last_name": null}]}
    |}]
;;

let%expect_test "validate from a record - elements" =
  Yocaml.Data.record
    [ ( "elements"
      , [ Person.make "a"; Person.make "b" ]
        |> Yocaml.Data.list_of Person.to_data )
    ]
  |> SP.from_data
  |> dump_validation SP.to_data;
  [%expect
    {|
    [V]	{"kind": "set", "length": 2, "is_empty": false, "is_not_empty": true,
        "elements":
         [{"display_name": "a", "first_name": null, "last_name": null},
         {"display_name": "b", "first_name": null, "last_name": null}]}
    |}]
;;
