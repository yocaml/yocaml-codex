open Codex_atoms
open Test_util

let%expect_test "Invalid ISBN validation" =
  "invalid ISBN"
  |> Yocaml.Data.string
  |> Isbn.from_data
  |> dump_validation Isbn.to_data;
  [%expect
    {|
    [X] --- Oh dear, an error has occurred ---
    Validation error:
    Entity: `test`

    Message:
      Message: Invalid ISBN
      Given: `invalid ISBN`---
    The backtrace is not available because the function is called (according to the [in_exception_handler] parameter) outside an exception handler. This makes the trace unspecified.
    |}]
;;

let%expect_test "Invalid ISBN validation" =
  "1234" |> Yocaml.Data.string |> Isbn.from_data |> dump_validation Isbn.to_data;
  [%expect
    {|
    [X] --- Oh dear, an error has occurred ---
    Validation error:
    Entity: `test`

    Message:
      Message: An ISBN must consist of 10 or 13 digits
      Given: `1234`---
    The backtrace is not available because the function is called (according to the [in_exception_handler] parameter) outside an exception handler. This makes the trace unspecified.
    |}]
;;

let%expect_test "Valid ISBN validation" =
  "978-2-0200-5837-7"
  |> Yocaml.Data.string
  |> Isbn.from_data
  |> dump_validation Isbn.to_data;
  [%expect
    {|
    [V] {"value": "9782020058377", "kind": 13, "repr": "978-2-0200-5837-7",
        "target":
         {"target": "https://isbnsearch.org/isbn/9782020058377", "scheme":
          "https", "host": "isbnsearch.org", "port":
          {"value": null, "exists": false}, "path": "/isbn/9782020058377",
         "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": {"value": null, "exists": false}}}
    |}]
;;

let%expect_test "Valid ISBN validation" =
  "9782020058377"
  |> Yocaml.Data.string
  |> Isbn.from_data
  |> dump_validation Isbn.to_data;
  [%expect
    {|
    [V] {"value": "9782020058377", "kind": 13, "repr": "978-2-0200-5837-7",
        "target":
         {"target": "https://isbnsearch.org/isbn/9782020058377", "scheme":
          "https", "host": "isbnsearch.org", "port":
          {"value": null, "exists": false}, "path": "/isbn/9782020058377",
         "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": {"value": null, "exists": false}}}
    |}]
;;

let%expect_test "Valid ISBN validation" =
  "2-0200-5837-7"
  |> Yocaml.Data.string
  |> Isbn.from_data
  |> dump_validation Isbn.to_data;
  [%expect
    {|
    [V] {"value": "2020058377", "kind": 10, "repr": "2-0200-5837-7", "target":
         {"target": "https://isbnsearch.org/isbn/2020058377", "scheme": "https",
         "host": "isbnsearch.org", "port": {"value": null, "exists": false},
         "path": "/isbn/2020058377", "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": {"value": null, "exists": false}}}
    |}]
;;

let%expect_test "Valid ISBN validation" =
  "2020058377"
  |> Yocaml.Data.string
  |> Isbn.from_data
  |> dump_validation Isbn.to_data;
  [%expect
    {|
    [V] {"value": "2020058377", "kind": 10, "repr": "2-0200-5837-7", "target":
         {"target": "https://isbnsearch.org/isbn/2020058377", "scheme": "https",
         "host": "isbnsearch.org", "port": {"value": null, "exists": false},
         "path": "/isbn/2020058377", "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": {"value": null, "exists": false}}}
    |}]
;;
