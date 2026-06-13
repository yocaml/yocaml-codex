open Codex_atoms
open Test_util

let%expect_test "dump url 1" =
  let url = Url.http "google.com" in
  dump_data Url.to_data url;
  [%expect
    {|
    {"target": "http://google.com", "scheme": "http", "host": "google.com",
    "port": {"value": null, "exists": false}, "path": "/", "query_params":
     {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
     "elements": []},
    "query_string": {"value": null, "exists": false}}
    |}]
;;

let%expect_test "dump url 2" =
  let url = Url.https "xvw.lol" in
  dump_data Url.to_data url;
  [%expect
    {|
    {"target": "https://xvw.lol", "scheme": "https", "host": "xvw.lol", "port":
     {"value": null, "exists": false}, "path": "/", "query_params":
     {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
     "elements": []},
    "query_string": {"value": null, "exists": false}}
    |}]
;;

let%expect_test "dump url 3" =
  let url = Url.https ~path:Yocaml.Path.(abs [ "index.html" ]) "xvw.lol/foo" in
  dump_data Url.to_data url;
  [%expect
    {|
    {"target": "https://xvw.lol/index.html", "scheme": "https", "host":
     "xvw.lol", "port": {"value": null, "exists": false}, "path": "/index.html",
    "query_params":
     {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
     "elements": []},
    "query_string": {"value": null, "exists": false}}
    |}]
;;

let%expect_test "dump url 4" =
  let url = Url.https ~path:Yocaml.Path.(rel [ "index.html" ]) "xvw.lol/foo" in
  dump_data Url.to_data url;
  [%expect
    {|
    {"target": "https://xvw.lol/foo/index.html", "scheme": "https", "host":
     "xvw.lol", "port": {"value": null, "exists": false}, "path":
     "/foo/index.html", "query_params":
     {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
     "elements": []},
    "query_string": {"value": null, "exists": false}}
    |}]
;;

let%expect_test "dump url 5" =
  let url = Url.https "xvw.lol?foo=bar,true&uname=xvw" in
  dump_data Url.to_data url;
  [%expect
    {|
    {"target": "https://xvw.lol?foo=bar,true&uname=xvw", "scheme": "https",
    "host": "xvw.lol", "port": {"value": null, "exists": false}, "path": "/",
    "query_params":
     {"kind": "map", "length": 2, "is_empty": false, "is_not_empty": true,
     "elements":
      [{"key": "foo", "value": ["bar", "true"]},
      {"key": "uname", "value": ["xvw"]}]},
    "query_string": {"value": "foo=bar,true&uname=xvw", "exists": true}}
    |}]
;;

let%expect_test "name of url 1" =
  let url = "xvw.lol?foo=bar,true&uname=xvw" |> Url.https |> Url.name in
  dump_data Yocaml.Data.string url;
  [%expect {| "xvw.lol" |}]
;;

let%expect_test "name of url 2" =
  let url = "xvw.lol/foo/bar?foo=bar,true&uname=xvw" |> Url.https |> Url.name in
  dump_data Yocaml.Data.string url;
  [%expect {| "xvw.lol/foo/bar" |}]
;;

let%expect_test "name of url 3" =
  let url =
    "xvw.lol/foo/bar?foo=bar,true&uname=xvw"
    |> Url.https
    |> Url.name ~with_path:false
  in
  dump_data Yocaml.Data.string url;
  [%expect {| "xvw.lol" |}]
;;

let%expect_test "name of url 4" =
  let url =
    "xvw.lol/foo/bar?foo=bar,true&uname=xvw"
    |> Url.https
    |> Url.name ~with_scheme:true
  in
  dump_data Yocaml.Data.string url;
  [%expect {| "https://xvw.lol/foo/bar" |}]
;;

let%expect_test "from_string corner case" =
  Url.from_data Yocaml.Data.(string "xvw.lol") |> dump_validation Url.to_data;
  [%expect
    {|
    [V] {"target": "https://xvw.lol", "scheme": "https", "host": "xvw.lol",
        "port": {"value": null, "exists": false}, "path": "/", "query_params":
         {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
         "elements": []},
        "query_string": {"value": null, "exists": false}}
    |}]
;;
