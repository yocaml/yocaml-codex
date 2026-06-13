open Test_util
open Codex_ontology

let%expect_test "Validate from a name" =
  inspect (module Company) Yocaml.Data.(string "Cargo Cut");
  [%expect
    {|
    [V] {"name": "Cargo Cut", "description": null, "small_logo": null,
        "large_logo": null, "logo": null, "cover": null, "url":
         {"main": null, "has_main": false, "other":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "all":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []}},
        "email":
         {"main": null, "has_main": false, "other":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "all":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []}},
        "social_accounts":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "has_description": false, "has_small_logo": false, "has_large_logo":
         false, "has_logo": false}
    |}]
;;

let%expect_test "Validate from a mailbox" =
  inspect
    (module Company)
    Yocaml.Data.(string "Cargo Cut <contact@cargocuuuut.com>");
  [%expect
    {|
    [V] {"name": "Cargo Cut", "description": null, "small_logo": null,
        "large_logo": null, "logo": null, "cover": null, "url":
         {"main": null, "has_main": false, "other":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "all":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []}},
        "email":
         {"main":
          {"address": "contact@cargocuuuut.com", "local": "contact", "domain":
           "cargocuuuut.com", "md5": "fac033c69636e84d78d1073388fcc902"},
         "has_main": true, "other":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "all":
          {"kind": "set", "length": 1, "is_empty": false, "is_not_empty": true,
          "elements":
           [{"address": "contact@cargocuuuut.com", "local": "contact", "domain":
             "cargocuuuut.com", "md5": "fac033c69636e84d78d1073388fcc902"}]}},
        "social_accounts":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "has_description": false, "has_small_logo": false, "has_large_logo":
         false, "has_logo": false}
    |}]
;;

let%expect_test "Validate from a record" =
  inspect
    (module Company)
    Yocaml.Data.(
      record
        [ "name", string "Cargo Kult"
        ; "url", string "https://thecargokult.com"
        ]);
  [%expect
    {|
    [V] {"name": "Cargo Kult", "description": null, "small_logo": null,
        "large_logo": null, "logo": null, "cover": null, "url":
         {"main":
          {"target": "https://thecargokult.com", "scheme": "https", "host":
           "thecargokult.com", "port": null, "path": "/", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_main": true, "other":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "all":
          {"kind": "set", "length": 1, "is_empty": false, "is_not_empty": true,
          "elements":
           [{"target": "https://thecargokult.com", "scheme": "https", "host":
             "thecargokult.com", "port": null, "path": "/", "has_port": false,
            "query_params":
             {"kind": "map", "length": 0, "is_empty": true, "is_not_empty":
              false, "elements": []},
            "query_string": null, "has_query_string": false}]}},
        "email":
         {"main": null, "has_main": false, "other":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "all":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []}},
        "social_accounts":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "has_description": false, "has_small_logo": false, "has_large_logo":
         false, "has_logo": false}
    |}]
;;
