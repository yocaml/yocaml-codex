open Test_util
open Codex_atoms

let%expect_test "Validate an external path" =
  let input =
    let open Yocaml.Data in
    string "https://www.xvw.lol"
  in
  input |> Scoped_url.from_data |> dump_validation Scoped_url.to_data;
  [%expect
    {|
    [V] {"kind": "external", "target": "https://www.xvw.lol", "url":
         {"target": "https://www.xvw.lol", "scheme": "https", "host":
          "www.xvw.lol", "port": null, "path": "/", "has_port": false,
         "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "Validate an internal absolute path" =
  let input =
    let open Yocaml.Data in
    string "/foo/bar"
  in
  input |> Scoped_url.from_data |> dump_validation Scoped_url.to_data;
  [%expect {| [V] {"kind": "internal", "target": "/foo/bar"} |}]
;;

let%expect_test "Validate an internal relative path" =
  let input =
    let open Yocaml.Data in
    string "foo/bar"
  in
  input |> Scoped_url.from_data |> dump_validation Scoped_url.to_data;
  [%expect {| [V] {"kind": "internal", "target": "./foo/bar"} |}]
;;
