open Test_util
open Codex_atoms

let%expect_test "Dump a gender - 1" =
  Yocaml.Data.string "male"
  |> Gender.from_data
  |> dump_validation Gender.to_data;
  [%expect
    {|
    [V] {"name": "male", "has_pronouns": true, "pronouns":
         {"has": true, "all": ["he", "him", "his"], "repr": "he/him/his"}}
    |}]
;;

let%expect_test "Dump a gender - 2" =
  Yocaml.Data.string "female"
  |> Gender.from_data
  |> dump_validation Gender.to_data;
  [%expect
    {|
    [V] {"name": "female", "has_pronouns": true, "pronouns":
         {"has": true, "all": ["she", "her", "hers"], "repr": "she/her/hers"}}
    |}]
;;

let%expect_test "Dump a gender - 4" =
  Yocaml.Data.string "neutral"
  |> Gender.from_data
  |> dump_validation Gender.to_data;
  [%expect
    {|
    [V] {"name": "neutral", "has_pronouns": false, "pronouns":
         {"has": false, "all": [], "repr": ""}}
    |}]
;;

let%expect_test "Dump a gender - 5" =
  Yocaml.Data.(record [ "name", string "female" ])
  |> Gender.from_data
  |> dump_validation Gender.to_data;
  [%expect
    {|
    [V] {"name": "female", "has_pronouns": true, "pronouns":
         {"has": true, "all": ["she", "her", "hers"], "repr": "she/her/hers"}}
    |}]
;;

let%expect_test "Dump a gender - 6" =
  Yocaml.Data.(record [ "name", string "female"; "pronouns", string "<none>" ])
  |> Gender.from_data
  |> dump_validation Gender.to_data;
  [%expect
    {|
    [V] {"name": "female", "has_pronouns": false, "pronouns":
         {"has": false, "all": [], "repr": ""}}
    |}]
;;

let%expect_test "Dump a gender - 7" =
  Yocaml.Data.(
    record
      [ "name", string "female"
      ; "pronouns", list_of string [ "   they"; "xxx" ]
      ])
  |> Gender.from_data
  |> dump_validation Gender.to_data;
  [%expect
    {|
    [V] {"name": "female", "has_pronouns": true, "pronouns":
         {"has": true, "all": ["they", "xxx"], "repr": "they/xxx"}}
    |}]
;;

let%expect_test "Dump a gender - 8" =
  Yocaml.Data.(
    record [ "name", string "female"; "pronouns", string "a/ b/ ccc /ddd" ])
  |> Gender.from_data
  |> dump_validation Gender.to_data;
  [%expect
    {|
    [V] {"name": "female", "has_pronouns": true, "pronouns":
         {"has": true, "all": ["a", "b", "ccc", "ddd"], "repr": "a/b/ccc/ddd"}}
    |}]
;;
