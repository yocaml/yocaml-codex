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
    [V] {"display_name": "Xavier", "bio": null, "slug": "xavier", "first_name":
         null, "last_name": null, "gender": null, "email": null, "url": null,
        "other_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "other_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "has_first_name": false, "has_last_name": false, "has_email": false,
        "has_url": false, "has_names": false, "has_gender": false, "with_names":
         null}
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
    [V] {"display_name": "Xavier Van de Woestyne", "bio": null, "slug":
         "xavier-van-de-woestyne", "first_name": "Xavier", "last_name":
         "Van de Woestyne", "gender": null, "email": null, "url": null,
        "other_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "other_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "has_first_name": true, "has_last_name": true, "has_email": false,
        "has_url": false, "has_names": true, "has_gender": false, "with_names":
         {"initials": "xv", "display": "X. Van de Woestyne"}}
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
    [V] {"display_name": "xvw", "bio": null, "slug": "xvw", "first_name":
         "Xavier", "last_name": "Van de Woestyne", "gender": null, "email":
         null, "url": null, "other_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "other_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "has_first_name": true, "has_last_name": true, "has_email": false,
        "has_url": false, "has_names": true, "has_gender": false, "with_names":
         {"initials": "xv", "display": "X. Van de Woestyne"}}
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
    [V] {"display_name": "xvw", "bio": null, "slug": "xvw", "first_name":
         "Xavier", "last_name": "Van de Woestyne", "gender": null, "email":
         null, "url": null, "other_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "other_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "has_first_name": true, "has_last_name": true, "has_email": false,
        "has_url": false, "has_names": true, "has_gender": false, "with_names":
         {"initials": "xv", "display": "X. Van de Woestyne"}}
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
    [V] {"display_name": "xvw", "bio": null, "slug": "xvw", "first_name": null,
        "last_name": null, "gender": null, "email": null, "url": null,
        "other_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "other_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "has_first_name": false, "has_last_name": false, "has_email": false,
        "has_url": false, "has_names": false, "has_gender": false, "with_names":
         null}
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
    [V] {"display_name": "Xavier van de Woestyne", "bio": null, "slug":
         "xavier-van-de-woestyne", "first_name": "Xavier", "last_name":
         "van de Woestyne", "gender": null, "email": null, "url": null,
        "other_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "other_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "has_first_name": true, "has_last_name": true, "has_email": false,
        "has_url": false, "has_names": true, "has_gender": false, "with_names":
         {"initials": "xv", "display": "X. van de Woestyne"}}
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
    [V] {"display_name": "Xavier van de Woestyne", "bio": null, "slug":
         "xavier-van-de-woestyne", "first_name": "Xavier", "last_name":
         "van de Woestyne", "gender":
         {"name": "male", "has_pronouns": true, "pronouns":
          {"has": true, "all": ["he", "him", "his"], "repr": "he/him/his"}},
        "email": null, "url": null, "other_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "other_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "has_first_name": true, "has_last_name": true, "has_email": false,
        "has_url": false, "has_names": true, "has_gender": true, "with_names":
         {"initials": "xv", "display": "X. van de Woestyne"}}
    |}]
;;

let%expect_test "Validating a simple name using record - 4" =
  let input =
    let open Yocaml.Data in
    record
      [ "first_name", string "xavier"
      ; "last_name", string "van de Woestyne"
      ; "gender", string "male"
      ; "email", string "xavier@me.com"
      ]
  in
  input |> Individual.from_data |> dump_validation Individual.to_data;
  [%expect
    {|
    [V] {"display_name": "Xavier van de Woestyne", "bio": null, "slug":
         "xavier-van-de-woestyne", "first_name": "Xavier", "last_name":
         "van de Woestyne", "gender":
         {"name": "male", "has_pronouns": true, "pronouns":
          {"has": true, "all": ["he", "him", "his"], "repr": "he/him/his"}},
        "email":
         {"address": "xavier@me.com", "local": "xavier", "domain": "me.com",
         "md5": "4ef27adaff5118935a2f8c00df083b91"},
        "url": null, "other_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_emails":
         {"kind": "set", "length": 1, "is_empty": false, "is_not_empty": true,
         "elements":
          [{"address": "xavier@me.com", "local": "xavier", "domain": "me.com",
           "md5": "4ef27adaff5118935a2f8c00df083b91"}]},
        "other_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "has_first_name": true, "has_last_name": true, "has_email": true,
        "has_url": false, "has_names": true, "has_gender": true, "with_names":
         {"initials": "xv", "display": "X. van de Woestyne"}}
    |}]
;;

let%expect_test "Validating a simple name from a mailbox" =
  let input =
    let open Yocaml.Data in
    string "Xavier Van de Woestyne <xavier@email.com>"
  in
  input |> Individual.from_data |> dump_validation Individual.to_data;
  [%expect
    {|
    [V] {"display_name": "Xavier Van de Woestyne", "bio": null, "slug":
         "xavier-van-de-woestyne", "first_name": null, "last_name": null,
        "gender": null, "email":
         {"address": "xavier@email.com", "local": "xavier", "domain":
          "email.com", "md5": "216a49d3e59a26adc15efc498e79708d"},
        "url": null, "other_emails":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_emails":
         {"kind": "set", "length": 1, "is_empty": false, "is_not_empty": true,
         "elements":
          [{"address": "xavier@email.com", "local": "xavier", "domain":
            "email.com", "md5": "216a49d3e59a26adc15efc498e79708d"}]},
        "other_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "has_first_name": false, "has_last_name": false, "has_email": true,
        "has_url": false, "has_names": false, "has_gender": false, "with_names":
         null}
    |}]
;;

let%expect_test "Validating a simple name using record" =
  let input =
    let open Yocaml.Data in
    record
      [ "first_name", string "xavier"
      ; "last_name", string "van de Woestyne"
      ; "emails", list_of string [ "xavier@mail.com"; "foo@t.org" ]
      ]
  in
  input |> Individual.from_data |> dump_validation Individual.to_data;
  [%expect
    {|
    [V] {"display_name": "Xavier van de Woestyne", "bio": null, "slug":
         "xavier-van-de-woestyne", "first_name": "Xavier", "last_name":
         "van de Woestyne", "gender": null, "email":
         {"address": "foo@t.org", "local": "foo", "domain": "t.org", "md5":
          "58d278c4f6116f5800db2e6137b25843"},
        "url": null, "other_emails":
         {"kind": "set", "length": 1, "is_empty": false, "is_not_empty": true,
         "elements":
          [{"address": "xavier@mail.com", "local": "xavier", "domain":
            "mail.com", "md5": "c05f09e2f2505e07efcec0bf0037ceba"}]},
        "all_emails":
         {"kind": "set", "length": 2, "is_empty": false, "is_not_empty": true,
         "elements":
          [{"address": "foo@t.org", "local": "foo", "domain": "t.org", "md5":
            "58d278c4f6116f5800db2e6137b25843"},
          {"address": "xavier@mail.com", "local": "xavier", "domain":
           "mail.com", "md5": "c05f09e2f2505e07efcec0bf0037ceba"}]},
        "other_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "all_urls":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "has_first_name": true, "has_last_name": true, "has_email": true,
        "has_url": false, "has_names": true, "has_gender": false, "with_names":
         {"initials": "xv", "display": "X. van de Woestyne"}}
    |}]
;;

let%expect_test "Validating a simple name using record" =
  let input =
    let open Yocaml.Data in
    record
      [ "first_name", string "xavier"
      ; "last_name", string "van de Woestyne"
      ; "email", string "foo@gmail.com"
      ; "emails", list_of string [ "xavier@mail.com"; "foo@t.org" ]
      ; "urls", list_of string [ "https://xvw.lol"; "http://yyy.org" ]
      ]
  in
  input |> Individual.from_data |> dump_validation Individual.to_data;
  [%expect {|
    [V] {"display_name": "Xavier van de Woestyne", "bio": null, "slug":
         "xavier-van-de-woestyne", "first_name": "Xavier", "last_name":
         "van de Woestyne", "gender": null, "email":
         {"address": "foo@gmail.com", "local": "foo", "domain": "gmail.com",
         "md5": "6c0fbec2cc554c35c3d2b8b51840b49d"},
        "url":
         {"target": "https://xvw.lol", "scheme": "https", "host": "xvw.lol",
         "port": null, "path": "/", "has_port": false, "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": null, "has_query_string": false},
        "other_emails":
         {"kind": "set", "length": 2, "is_empty": false, "is_not_empty": true,
         "elements":
          [{"address": "foo@t.org", "local": "foo", "domain": "t.org", "md5":
            "58d278c4f6116f5800db2e6137b25843"},
          {"address": "xavier@mail.com", "local": "xavier", "domain":
           "mail.com", "md5": "c05f09e2f2505e07efcec0bf0037ceba"}]},
        "all_emails":
         {"kind": "set", "length": 3, "is_empty": false, "is_not_empty": true,
         "elements":
          [{"address": "foo@gmail.com", "local": "foo", "domain": "gmail.com",
           "md5": "6c0fbec2cc554c35c3d2b8b51840b49d"},
          {"address": "foo@t.org", "local": "foo", "domain": "t.org", "md5":
           "58d278c4f6116f5800db2e6137b25843"},
          {"address": "xavier@mail.com", "local": "xavier", "domain":
           "mail.com", "md5": "c05f09e2f2505e07efcec0bf0037ceba"}]},
        "other_urls":
         {"kind": "set", "length": 1, "is_empty": false, "is_not_empty": true,
         "elements":
          [{"target": "http://yyy.org", "scheme": "http", "host": "yyy.org",
           "port": null, "path": "/", "has_port": false, "query_params":
            {"kind": "map", "length": 0, "is_empty": true, "is_not_empty":
             false, "elements": []},
           "query_string": null, "has_query_string": false}]},
        "all_urls":
         {"kind": "set", "length": 2, "is_empty": false, "is_not_empty": true,
         "elements":
          [{"target": "https://xvw.lol", "scheme": "https", "host": "xvw.lol",
           "port": null, "path": "/", "has_port": false, "query_params":
            {"kind": "map", "length": 0, "is_empty": true, "is_not_empty":
             false, "elements": []},
           "query_string": null, "has_query_string": false},
          {"target": "http://yyy.org", "scheme": "http", "host": "yyy.org",
          "port": null, "path": "/", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false}]},
        "has_first_name": true, "has_last_name": true, "has_email": true,
        "has_url": true, "has_names": true, "has_gender": false, "with_names":
         {"initials": "xv", "display": "X. van de Woestyne"}}
    |}]
;;
