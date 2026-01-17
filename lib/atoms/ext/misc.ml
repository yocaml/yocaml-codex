module Ext_string = String

let in_str_enum ?(case_sensitive = false) enum x =
  let f =
    if case_sensitive then fun x -> x else Stdlib.String.lowercase_ascii
  in
  Stdlib.List.exists
    (fun elt ->
       let a = f elt
       and b = f x in
       Stdlib.String.equal a b)
    enum
;;

let split_path p =
  p
  |> Stdlib.String.split_on_char '/'
  |> Stdlib.List.map (fun x ->
    x
    |> String.trim_when (function
      | ' ' | '\012' | '\n' | '\r' | '\t' | '@' | '~' -> true
      | _ -> false)
    |> Stdlib.String.lowercase_ascii)
;;

let ltrim_path = function
  | x :: xs when Stdlib.String.(equal (trim x)) "" -> xs
  | xs -> xs
;;

let as_name =
  let open Yocaml.Data.Validation in
  (string
   $ fun x ->
   x
   |> Stdlib.String.trim
   |> Ext_string.remove_leading_arobase
   |> Ext_string.remove_leading_char_when (function
     | '@' | '~' -> true
     | _ -> false))
  & String.not_blank
;;

let add_scheme ?(scheme = "https") s =
  match Stdlib.String.split_on_char ':' s with
  | _ :: ([ xs ] | xs :: _) when Stdlib.String.starts_with ~prefix:"//" xs -> s
  | _ -> scheme ^ "://" ^ s
;;
