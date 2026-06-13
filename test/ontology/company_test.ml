open Test_util
open Codex_ontology

let%expect_test "Validate from a name" =
  inspect (module Company) Yocaml.Data.(string "Cargo Cut");
  [%expect
    {|
    [V] {"name": "Cargo Cut", "description": {"value": null, "exists": false},
        "small_logo": {"value": null, "exists": false}, "large_logo":
         {"value": null, "exists": false}, "logo":
         {"value": null, "exists": false}, "cover":
         {"value": null, "exists": false}, "url":
         {"main": {"value": null, "exists": false}, "other":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "all":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []}},
        "email":
         {"main": {"value": null, "exists": false}, "other":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "all":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []}},
        "social_accounts":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []}}
    |}]
;;

let%expect_test "Validate from a mailbox" =
  inspect
    (module Company)
    Yocaml.Data.(string "Cargo Cut <contact@cargocuuuut.com>");
  [%expect
    {|
    [V] {"name": "Cargo Cut", "description": {"value": null, "exists": false},
        "small_logo": {"value": null, "exists": false}, "large_logo":
         {"value": null, "exists": false}, "logo":
         {"value": null, "exists": false}, "cover":
         {"value": null, "exists": false}, "url":
         {"main": {"value": null, "exists": false}, "other":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "all":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []}},
        "email":
         {"main":
          {"value":
           {"address": "contact@cargocuuuut.com", "local": "contact", "domain":
            "cargocuuuut.com", "md5": "fac033c69636e84d78d1073388fcc902"},
          "exists": true},
         "other":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "all":
          {"kind": "set", "length": 1, "is_empty": false, "is_not_empty": true,
          "elements":
           [{"address": "contact@cargocuuuut.com", "local": "contact", "domain":
             "cargocuuuut.com", "md5": "fac033c69636e84d78d1073388fcc902"}]}},
        "social_accounts":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []}}
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
    [V] {"name": "Cargo Kult", "description": {"value": null, "exists": false},
        "small_logo": {"value": null, "exists": false}, "large_logo":
         {"value": null, "exists": false}, "logo":
         {"value": null, "exists": false}, "cover":
         {"value": null, "exists": false}, "url":
         {"main":
          {"value":
           {"target": "https://thecargokult.com", "scheme": "https", "host":
            "thecargokult.com", "port": {"value": null, "exists": false}, "path":
            "/", "query_params":
            {"kind": "map", "length": 0, "is_empty": true, "is_not_empty":
             false, "elements": []},
           "query_string": {"value": null, "exists": false}},
          "exists": true},
         "other":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "all":
          {"kind": "set", "length": 1, "is_empty": false, "is_not_empty": true,
          "elements":
           [{"target": "https://thecargokult.com", "scheme": "https", "host":
             "thecargokult.com", "port": {"value": null, "exists": false},
            "path": "/", "query_params":
             {"kind": "map", "length": 0, "is_empty": true, "is_not_empty":
              false, "elements": []},
            "query_string": {"value": null, "exists": false}}]}},
        "email":
         {"main": {"value": null, "exists": false}, "other":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "all":
          {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []}},
        "social_accounts":
         {"kind": "set", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []}}
    |}]
;;
