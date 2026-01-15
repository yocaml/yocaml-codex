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

let as_name =
  let open Yocaml.Data.Validation in
  (string
   $ fun x ->
   x
   |> Stdlib.String.trim
   |> Stdlib.String.lowercase_ascii
   |> Ext_string.remove_leading_arobase)
  & String.not_blank
;;
