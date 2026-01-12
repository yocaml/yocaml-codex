open Codex_atoms
open Test_util

let%expect_test "validate a link - from a simple URL" =
  Yocaml.Data.(string "https://xvw.lol/foo")
  |> Link.from_data
  |> dump_validation Link.to_data;
  [%expect
    {|
    [V]	{"name": "xvw.lol/foo", "url":
         {"target": "https://xvw.lol/foo", "scheme": "https", "host": "xvw.lol",
         "port": null, "path": "/foo", "has_port": false, "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": null, "has_query_string": false},
        "target": "https://xvw.lol/foo", "description": null, "has_description":
         false}
    |}]
;;

let%expect_test "validate a link - from an url 2" =
  Yocaml.Data.(record [ "url", string "https://xvw.lol/foo" ])
  |> Link.from_data
  |> dump_validation Link.to_data;
  [%expect
    {|
    [V]	{"name": "xvw.lol/foo", "url":
         {"target": "https://xvw.lol/foo", "scheme": "https", "host": "xvw.lol",
         "port": null, "path": "/foo", "has_port": false, "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": null, "has_query_string": false},
        "target": "https://xvw.lol/foo", "description": null, "has_description":
         false}
    |}]
;;

let%expect_test "validate a link - from an url with a name" =
  Yocaml.Data.(
    record [ "url", string "https://xvw.lol/foo"; "name", string "xvw" ])
  |> Link.from_data
  |> dump_validation Link.to_data;
  [%expect
    {|
    [V]	{"name": "xvw", "url":
         {"target": "https://xvw.lol/foo", "scheme": "https", "host": "xvw.lol",
         "port": null, "path": "/foo", "has_port": false, "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": null, "has_query_string": false},
        "target": "https://xvw.lol/foo", "description": null, "has_description":
         false}
    |}]
;;

let%expect_test "validate a link - from an url with a name 2" =
  Yocaml.Data.(
    record [ "target", string "https://xvw.lol/foo"; "name", string "xvw" ])
  |> Link.from_data
  |> dump_validation Link.to_data;
  [%expect
    {|
    [V]	{"name": "xvw", "url":
         {"target": "https://xvw.lol/foo", "scheme": "https", "host": "xvw.lol",
         "port": null, "path": "/foo", "has_port": false, "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": null, "has_query_string": false},
        "target": "https://xvw.lol/foo", "description": null, "has_description":
         false}
    |}]
;;

let%expect_test "validate a link - from an url with a name and desc" =
  Yocaml.Data.(
    record
      [ "target", string "https://xvw.lol/foo"
      ; "name", string "xvw"
      ; "desc", string "A description"
      ])
  |> Link.from_data
  |> dump_validation Link.to_data;
  [%expect
    {|
    [V]	{"name": "xvw", "url":
         {"target": "https://xvw.lol/foo", "scheme": "https", "host": "xvw.lol",
         "port": null, "path": "/foo", "has_port": false, "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": null, "has_query_string": false},
        "target": "https://xvw.lol/foo", "description": "A description",
        "has_description": true}
    |}]
;;
