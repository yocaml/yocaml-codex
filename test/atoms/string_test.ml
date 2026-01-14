open Codex_atoms
open Test_util

let%expect_test "from_char" =
  [ '0'; '1'; '2'; '3'; '4'; '!'; 'c'; 'a'; 'A'; 'D'; '='; '%'; '^'; '\'' ]
  |> List.map Ext.String.from_char
  |> String.concat ""
  |> dump_string;
  [%expect {| 01234!caAD=%^' |}]
;;

let%expect_test "char_at" =
  let s = "abc" in
  Ext.String.
    [ char_at 0 s
    ; char_at 1 s
    ; char_at 2 s
    ; char_at (-1) s
    ; char_at 3 s
    ; char_at 0 ""
    ]
  |> dump_opt_list Ext.String.from_char;
  [%expect {| `Some(a)`; `Some(b)`; `Some(c)`; `None`; `None`; `None` |}]
;;

let%expect_test "from_list" =
  Ext.String.
    [ from_list (fun x -> x) []
    ; from_list string_of_int [ 1 ]
    ; from_list string_of_int [ 1; 2; 3 ]
    ; from_list string_of_bool [ true; false; true ]
    ]
  |> dump_list Fun.id;
  [%expect {| ``; `1`; `123`; `truefalsetrue` |}]
;;

let%expect_test "from_filtered_list" =
  Ext.String.
    [ from_filtered_list
        (fun x -> if x mod 2 = 0 then None else Some (string_of_int x))
        []
    ; from_filtered_list
        (fun x -> if x mod 2 = 0 then None else Some (string_of_int x))
        [ 1; 2; 3 ]
    ; from_filtered_list
        (fun x -> if x then Some "t" else None)
        [ true; false; true ]
    ]
  |> dump_list Fun.id;
  [%expect {| ``; `13`; `tt` |}]
;;

let%expect_test "from_char_list" =
  Ext.String.
    [ from_char_list []
    ; from_char_list [ 'a' ]
    ; from_char_list [ 'a'; 'B'; 'C' ]
    ; from_char_list [ '0'; '1'; '2'; '3'; '4' ]
    ]
  |> dump_list Fun.id;
  [%expect {| ``; `a`; `aBC`; `01234` |}]
;;

let%expect_test "to_list" =
  Ext.String.[ to_list Fun.id ""; to_list Fun.id "a"; to_list Fun.id "aBcDE8" ]
  |> dump_list Ext.String.from_char_list;
  [%expect {| ``; `a`; `aBcDE8` |}]
;;

let%expect_test "to_char_list" =
  Ext.String.[ to_char_list ""; to_char_list "a"; to_char_list "aBcDE8" ]
  |> dump_list Ext.String.from_char_list;
  [%expect {| ``; `a`; `aBcDE8` |}]
;;

let%expect_test "concat_with" =
  Ext.String.
    [ concat_with ~sep:", " string_of_int []
    ; concat_with ~sep:", " string_of_int [ 1; 2; 3 ]
    ; concat_with ~sep:"hehe" Fun.id [ "foo"; "bar" ]
    ; concat_with ~sep:"hehe" Fun.id [ "foo" ]
    ]
  |> dump_list Fun.id;
  [%expect {| ``; `1, 2, 3`; `foohehebar`; `foo` |}]
;;

let%expect_test "ltrim_when" =
  let ltrim =
    Ext.String.ltrim_when (function
      | '0' .. '9' -> true
      | _ -> false)
  in
  [ "123344foo"; "1234345"; "1234foo00098" ] |> dump_list ltrim;
  [%expect {| `foo`; ``; `foo00098` |}]
;;

let%expect_test "rtrim_when" =
  let ltrim =
    Ext.String.rtrim_when (function
      | '0' .. '9' -> true
      | _ -> false)
  in
  [ "foo123344"; "1234345"; "1234foo00098" ] |> dump_list ltrim;
  [%expect {| `foo`; ``; `1234foo` |}]
;;

let%expect_test "trim_when" =
  let ltrim =
    Ext.String.trim_when (function
      | '0' .. '9' -> true
      | _ -> false)
  in
  [ "foo123344"; "1234345"; "1234foo00098" ] |> dump_list ltrim;
  [%expect {| `foo`; ``; `foo` |}]
;;

let%expect_test "remove_leading_char_when" =
  let ltrim =
    Ext.String.remove_leading_char_when (function
      | '0' .. '9' -> true
      | _ -> false)
  in
  [ "1foo123344"; "1234345"; "1234foo00098" ] |> dump_list ltrim;
  [%expect {| `foo123344`; `234345`; `234foo00098` |}]
;;

let%expect_test "remove_leading_arobase" =
  [ "@1foo123344"; "1234345"; "@@1234foo00098" ]
  |> dump_list Ext.String.remove_leading_arobase;
  [%expect {| `1foo123344`; `1234345`; `@1234foo00098` |}]
;;

let%expect_test "remove_leading_hash" =
  [ "#1foo123344"; "1234345"; "##1234foo00098" ]
  |> dump_list Ext.String.remove_leading_hash;
  [%expect {| `1foo123344`; `1234345`; `#1234foo00098` |}]
;;

let%expect_test "remove_leading_dot" =
  [ ".1foo123344"; "1234345."; "..1234foo00098." ]
  |> dump_list Ext.String.remove_leading_dot;
  [%expect {| `1foo123344`; `1234345.`; `.1234foo00098.` |}]
;;
