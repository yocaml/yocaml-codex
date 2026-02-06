open Codex_atoms
open Test_util

let%expect_test "validate a language - from string (code only)" =
  Yocaml.Data.string "en"
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [V]	{"tag": "en", "code": "en", "region": null, "has_region": false}
    |}]
;;

let%expect_test "validate a language - from string (code + region)" =
  Yocaml.Data.string "en-KE"
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [V]	{"tag": "en-KE", "code": "en", "region": "KE", "has_region": true}
    |}]
;;

let%expect_test "validate a language - from canonical English name" =
  Yocaml.Data.string "English"
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [V]	{"tag": "en", "code": "en", "region": null, "has_region": false}
    |}]
;;

let%expect_test "validate a language - from record (code only)" =
  Yocaml.Data.(record [ "code", string "en" ])
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [V]	{"tag": "en", "code": "en", "region": null, "has_region": false}
    |}]
;;

let%expect_test "validate a language - from record (code + region)" =
  Yocaml.Data.(record [ "code", string "en"; "region", string "KE" ])
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [V]	{"tag": "en-KE", "code": "en", "region": "KE", "has_region": true}
    |}]
;;

let%expect_test "validate a language - record with canonical name" =
  Yocaml.Data.(record [ "code", string "English" ])
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [V]	{"tag": "en", "code": "en", "region": null, "has_region": false}
    |}]
;;

let%expect_test "reject an unknown language" =
  Yocaml.Data.string "Banana"
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [E]	Unknown language
    |}]
;;

let%expect_test "reject invalid language format" =
  Yocaml.Data.string "en-KE-extra"
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [E]	Invalid language format
    |}]
;;