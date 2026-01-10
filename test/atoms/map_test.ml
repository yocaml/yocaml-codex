open Codex_atoms
open Test_util
module MP = Map.Make (Person) (Person) (Person)

let%expect_test "normalize an empty map" =
  MP.empty |> dump_data (MP.to_data Yocaml.Data.string);
  [%expect
    {|
    {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
    "elements": []}
    |}]
;;

let%expect_test "normalize a map" =
  [ Person.make "a", "a"; Person.make "b", "b" ]
  |> MP.of_list
  |> dump_data (MP.to_data Yocaml.Data.string);
  [%expect
    {|
    {"kind": "map", "length": 2, "is_empty": false, "is_not_empty": true,
    "elements":
     [{"key": {"display_name": "a", "first_name": null, "last_name": null},
      "value": "a"},
     {"key": {"display_name": "b", "first_name": null, "last_name": null},
     "value": "b"}]}
    |}]
;;

let%expect_test "validate from an empty list" =
  []
  |> Yocaml.Data.list_of Person.to_data
  |> MP.from_data Yocaml.Data.Validation.string
  |> dump_validation (MP.to_data Yocaml.Data.string);
  [%expect
    {|
    [V]	{"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
        "elements": []}
    |}]
;;

let%expect_test "validate from a list" =
  [ Person.make "a", "a"; Person.make "b", "b" ]
  |> Yocaml.Data.(list_of (pair Person.to_data string))
  |> MP.from_data Yocaml.Data.Validation.string
  |> dump_validation (MP.to_data Yocaml.Data.string);
  [%expect
    {|
    [V]	{"kind": "map", "length": 2, "is_empty": false, "is_not_empty": true,
        "elements":
         [{"key": {"display_name": "a", "first_name": null, "last_name": null},
          "value": "a"},
         {"key": {"display_name": "b", "first_name": null, "last_name": null},
         "value": "b"}]}
    |}]
;;

let%expect_test "validate from a list - 2" =
  [ Person.make "a", "a"; Person.make "b", "b" ]
  |> Yocaml.Data.(list_of (fun (a, b) -> list [ Person.to_data a; string b ]))
  |> MP.from_data Yocaml.Data.Validation.string
  |> dump_validation (MP.to_data Yocaml.Data.string);
  [%expect
    {|
    [V]	{"kind": "map", "length": 2, "is_empty": false, "is_not_empty": true,
        "elements":
         [{"key": {"display_name": "a", "first_name": null, "last_name": null},
          "value": "a"},
         {"key": {"display_name": "b", "first_name": null, "last_name": null},
         "value": "b"}]}
    |}]
;;

let%expect_test "validate from a list - 3" =
  Yocaml.Data.
    [ record [ "key", Person.make "a" |> Person.to_data; "value", string "a" ]
    ; record [ "fst", Person.make "b" |> Person.to_data; "snd", string "b" ]
    ]
  |> Yocaml.Data.list
  |> MP.from_data Yocaml.Data.Validation.string
  |> dump_validation (MP.to_data Yocaml.Data.string);
  [%expect
    {|
    [V]	{"kind": "map", "length": 2, "is_empty": false, "is_not_empty": true,
        "elements":
         [{"key": {"display_name": "a", "first_name": null, "last_name": null},
          "value": "a"},
         {"key": {"display_name": "b", "first_name": null, "last_name": null},
         "value": "b"}]}
    |}]
;;

let%expect_test "validate from a record - all" =
  Yocaml.Data.(
    record
      [ ( "all"
        , list
            [ record
                [ "key", Person.make "a" |> Person.to_data
                ; "value", string "a"
                ]
            ; record
                [ "fst", Person.make "b" |> Person.to_data; "snd", string "b" ]
            ] )
      ])
  |> MP.from_data Yocaml.Data.Validation.string
  |> dump_validation (MP.to_data Yocaml.Data.string);
  [%expect
    {|
    [V]	{"kind": "map", "length": 2, "is_empty": false, "is_not_empty": true,
        "elements":
         [{"key": {"display_name": "a", "first_name": null, "last_name": null},
          "value": "a"},
         {"key": {"display_name": "b", "first_name": null, "last_name": null},
         "value": "b"}]}
    |}]
;;

let%expect_test "validate from a record - elements" =
  Yocaml.Data.(
    record
      [ ( "elements"
        , list
            [ record
                [ "key", Person.make "a" |> Person.to_data
                ; "value", string "a"
                ]
            ; record
                [ "fst", Person.make "b" |> Person.to_data; "snd", string "b" ]
            ] )
      ])
  |> MP.from_data Yocaml.Data.Validation.string
  |> dump_validation (MP.to_data Yocaml.Data.string);
  [%expect
    {|
    [V]	{"kind": "map", "length": 2, "is_empty": false, "is_not_empty": true,
        "elements":
         [{"key": {"display_name": "a", "first_name": null, "last_name": null},
          "value": "a"},
         {"key": {"display_name": "b", "first_name": null, "last_name": null},
         "value": "b"}]}
    |}]
;;
