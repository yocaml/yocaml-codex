open Codex_atoms
open Test_util

let%expect_test "dump url 1" =
  let url = Url.http "google.com" in
  dump_data Url.to_data url;
  [%expect
    {|
    {"target": "http://google.com", "scheme": "http", "host": "google.com",
    "port": null, "path": "/", "has_port": false, "query_params":
     {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
     "elements": []},
    "query_string": null, "has_query_string": false}
    |}]
;;

let%expect_test "dump url 2" =
  let url = Url.https "xvw.lol" in
  dump_data Url.to_data url;
  [%expect
    {|
    {"target": "https://xvw.lol", "scheme": "https", "host": "xvw.lol", "port":
     null, "path": "/", "has_port": false, "query_params":
     {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
     "elements": []},
    "query_string": null, "has_query_string": false}
    |}]
;;

let%expect_test "dump url 3" =
  let url = Url.https ~path:Yocaml.Path.(abs [ "index.html" ]) "xvw.lol/foo" in
  dump_data Url.to_data url;
  [%expect
    {|
    {"target": "https://xvw.lol/index.html", "scheme": "https", "host":
     "xvw.lol", "port": null, "path": "/index.html", "has_port": false,
    "query_params":
     {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
     "elements": []},
    "query_string": null, "has_query_string": false}
    |}]
;;

let%expect_test "dump url 4" =
  let url = Url.https ~path:Yocaml.Path.(rel [ "index.html" ]) "xvw.lol/foo" in
  dump_data Url.to_data url;
  [%expect
    {|
    {"target": "https://xvw.lol/foo/index.html", "scheme": "https", "host":
     "xvw.lol", "port": null, "path": "/foo/index.html", "has_port": false,
    "query_params":
     {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
     "elements": []},
    "query_string": null, "has_query_string": false}
    |}]
;;

let%expect_test "dump url 5" =
  let url = Url.https "xvw.lol?foo=bar,true&uname=xvw" in
  dump_data Url.to_data url;
  [%expect
    {|
    {"target": "https://xvw.lol?foo=bar,true&uname=xvw", "scheme": "https",
    "host": "xvw.lol", "port": null, "path": "/", "has_port": false,
    "query_params":
     {"kind": "map", "length": 2, "is_empty": false, "is_not_empty": true,
     "elements":
      [{"key": "foo", "value": ["bar", "true"]},
      {"key": "uname", "value": ["xvw"]}]},
    "query_string": "foo=bar,true&uname=xvw", "has_query_string": true}
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
