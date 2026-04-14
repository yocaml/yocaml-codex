open Test_util
open Codex_ontology

let%expect_test "Validating a simple name - 1" =
  let input =
    let open Yocaml.Data in
    string "Xavier"
  in
  input |> Individual.from_data |> dump_validation Individual.to_data;
  [%expect
    {|
    [V] {"display_name": "Xavier", "slug": "xavier", "first_name": null,
        "last_name": null, "gender": null, "has_first_name": false,
        "has_last_name": false, "has_names": false, "has_gender": false,
        "with_names": null}
    |}]
;;

let%expect_test "Validating a simple name - 2" =
  let input =
    let open Yocaml.Data in
    string "Xavier Van de Woestyne"
  in
  input |> Individual.from_data |> dump_validation Individual.to_data;
  [%expect
    {|
    [V] {"display_name": "Xavier Van de Woestyne", "slug":
         "xavier-van-de-woestyne", "first_name": "Xavier", "last_name":
         "Van de Woestyne", "gender": null, "has_first_name": true,
        "has_last_name": true, "has_names": true, "has_gender": false,
        "with_names": {"initials": "xv", "display": "X. Van de Woestyne"}}
    |}]
;;

let%expect_test "Validating a simple name with alias - 1" =
  let input =
    let open Yocaml.Data in
    string "Xavier / xvw / Van de Woestyne"
  in
  input |> Individual.from_data |> dump_validation Individual.to_data;
  [%expect
    {|
    [V] {"display_name": "xvw", "slug": "xvw", "first_name": "Xavier",
        "last_name": "Van de Woestyne", "gender": null, "has_first_name": true,
        "has_last_name": true, "has_names": true, "has_gender": false,
        "with_names": {"initials": "xv", "display": "X. Van de Woestyne"}}
    |}]
;;

let%expect_test "Validating a simple name with alias - 2" =
  let input =
    let open Yocaml.Data in
    string "Xavier/xvw/Van de Woestyne"
  in
  input |> Individual.from_data |> dump_validation Individual.to_data;
  [%expect
    {|
    [V] {"display_name": "xvw", "slug": "xvw", "first_name": "Xavier",
        "last_name": "Van de Woestyne", "gender": null, "has_first_name": true,
        "has_last_name": true, "has_names": true, "has_gender": false,
        "with_names": {"initials": "xv", "display": "X. Van de Woestyne"}}
    |}]
;;

let%expect_test "Validating a simple name using record" =
  let input =
    let open Yocaml.Data in
    record [ "display_name", string "xvw" ]
  in
  input |> Individual.from_data |> dump_validation Individual.to_data;
  [%expect
    {|
    [V] {"display_name": "xvw", "slug": "xvw", "first_name": null, "last_name":
         null, "gender": null, "has_first_name": false, "has_last_name": false,
        "has_names": false, "has_gender": false, "with_names": null}
    |}]
;;

let%expect_test "Validating a simple name using record - 2" =
  let input =
    let open Yocaml.Data in
    record
      [ "first_name", string "xavier"; "last_name", string "van de Woestyne" ]
  in
  input |> Individual.from_data |> dump_validation Individual.to_data;
  [%expect
    {|
    [V] {"display_name": "Xavier Van de Woestyne", "slug":
         "xavier-van-de-woestyne", "first_name": "Xavier", "last_name":
         "Van de Woestyne", "gender": null, "has_first_name": true,
        "has_last_name": true, "has_names": true, "has_gender": false,
        "with_names": {"initials": "xv", "display": "X. Van de Woestyne"}}
    |}]
;;

let%expect_test "Validating a simple name using record - 3" =
  let input =
    let open Yocaml.Data in
    record
      [ "first_name", string "xavier"
      ; "last_name", string "van de Woestyne"
      ; "gender", string "male"
      ]
  in
  input |> Individual.from_data |> dump_validation Individual.to_data;
  [%expect
    {|
    [V] {"display_name": "Xavier Van de Woestyne", "slug":
         "xavier-van-de-woestyne", "first_name": "Xavier", "last_name":
         "Van de Woestyne", "gender":
         {"name": "male", "has_pronouns": true, "pronouns":
          {"has": true, "all": ["he", "him", "his"], "repr": "he/him/his"}},
        "has_first_name": true, "has_last_name": true, "has_names": true,
        "has_gender": true, "with_names":
         {"initials": "xv", "display": "X. Van de Woestyne"}}
    |}]
;;
