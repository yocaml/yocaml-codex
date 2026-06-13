open Codex_atoms
open Test_util

let%expect_test "validate a language - from string (code only)" =
  Yocaml.Data.string "es"
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [V] {"tag": "es-ES", "code": "es", "iso639p1": "es", "iso639p2": "spa",
        "scope": "individual", "is_macro": false, "region":
         {"value": "ES", "exists": true}}
    |}]
;;

let%expect_test "validate a language - from string (code + region)" =
  Yocaml.Data.string "pt-PT"
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [V] {"tag": "pt-PT", "code": "pt", "iso639p1": "pt", "iso639p2": "por",
        "scope": "individual", "is_macro": false, "region":
         {"value": "PT", "exists": true}}
    |}]
;;

let%expect_test "validate a language - from canonical name (french)" =
  Yocaml.Data.string "french"
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [V] {"tag": "fr-FR", "code": "fr", "iso639p1": "fr", "iso639p2": "fra",
        "scope": "individual", "is_macro": false, "region":
         {"value": "FR", "exists": true}}
    |}]
;;

let%expect_test "validate a language - from canonical name (english)" =
  Yocaml.Data.string "english"
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [V] {"tag": "en-US", "code": "en", "iso639p1": "en", "iso639p2": "eng",
        "scope": "individual", "is_macro": false, "region":
         {"value": "US", "exists": true}}
    |}]
;;

let%expect_test "validate a language UK english" =
  Yocaml.Data.string "en-UK"
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [V] {"tag": "en-UK", "code": "en", "iso639p1": "en", "iso639p2": "eng",
        "scope": "individual", "is_macro": false, "region":
         {"value": "UK", "exists": true}}
    |}]
;;

let%expect_test "validate a language - from record (code only)" =
  Yocaml.Data.(record [ "code", string "de" ])
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [V] {"tag": "de-DE", "code": "de", "iso639p1": "de", "iso639p2": "deu",
        "scope": "individual", "is_macro": false, "region":
         {"value": "DE", "exists": true}}
    |}]
;;

let%expect_test "validate a language - record with name & country" =
  Yocaml.Data.(record [ "language", string "arabic"; "country", string "EG" ])
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [V] {"tag": "ar-EG", "code": "ar", "iso639p1": "ar", "iso639p2": "ara",
        "scope": "macro", "is_macro": true, "region":
         {"value": "EG", "exists": true}}
    |}]
;;

let%expect_test "reject an unknown language" =
  Yocaml.Data.string "klingon"
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [X] --- Oh dear, an error has occurred ---
    Validation error:
    Entity: `test`

    Message:
      Message: Unknown language
      Given: `klingon`---
    The backtrace is not available because the function is called (according to the [in_exception_handler] parameter) outside an exception handler. This makes the trace unspecified.
    |}]
;;

let%expect_test "reject invalid language format" =
  Yocaml.Data.string "zh-Hans-CN"
  |> Language.from_data
  |> dump_validation Language.to_data;
  [%expect
    {|
    [X] --- Oh dear, an error has occurred ---
    Validation error:
    Entity: `test`

    Message:
      Message: Invalid language format
      Given: `zh-Hans-CN`---
    The backtrace is not available because the function is called (according to the [in_exception_handler] parameter) outside an exception handler. This makes the trace unspecified.
    |}]
;;

let%expect_test "dump french" =
  Language.fr |> dump_data Language.to_data;
  [%expect
    {|
    {"tag": "fr-FR", "code": "fr", "iso639p1": "fr", "iso639p2": "fra", "scope":
     "individual", "is_macro": false, "region": {"value": "FR", "exists": true}}
    |}]
;;

let%expect_test "dump en-US" =
  Language.en_us |> dump_data Language.to_data;
  [%expect
    {|
    {"tag": "en-US", "code": "en", "iso639p1": "en", "iso639p2": "eng", "scope":
     "individual", "is_macro": false, "region": {"value": "US", "exists": true}}
    |}]
;;

let%expect_test "dump en-UK" =
  Language.en_uk |> dump_data Language.to_data;
  [%expect
    {|
    {"tag": "en-UK", "code": "en", "iso639p1": "en", "iso639p2": "eng", "scope":
     "individual", "is_macro": false, "region": {"value": "UK", "exists": true}}
    |}]
;;
