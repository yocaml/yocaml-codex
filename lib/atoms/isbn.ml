type kind =
  | T10
  | T13

type t =
  { value : string
  ; kind : kind
  }

let isbn_repr_10 offset isbn =
  let i x = isbn.[offset + x] in
  Format.asprintf
    "%c-%c%c%c%c-%c%c%c%c-%c"
    (i 0)
    (i 1)
    (i 2)
    (i 3)
    (i 4)
    (i 5)
    (i 6)
    (i 7)
    (i 8)
    (i 9)
;;

let to_string { value; kind } =
  match kind with
  | T10 -> isbn_repr_10 0 value
  | T13 ->
    Format.asprintf
      "%c%c%c-%s"
      value.[0]
      value.[1]
      value.[2]
      (isbn_repr_10 3 value)
;;

let make10 value = { kind = T10; value }
let make13 value = { kind = T13; value }
let value { value; _ } = value
let compare a b = String.compare (value a) (value b)
let equal a b = String.equal (value a) (value b)

let from_string str =
  let s =
    str
    |> Ext.String.split_on_chars (function
      | '-' | '_' | ':' | '\t' -> true
      | _ -> false)
    |> String.concat ""
  in
  if
    String.for_all
      (function
        | '0' .. '9' -> true
        | _ -> false)
      s
  then (
    let len = String.length s in
    if len = 10
    then Ok (make10 s)
    else if len = 13
    then Ok (make13 s)
    else
      Yocaml.Data.Validation.fail_with
        ~given:str
        "An ISBN must consist of 10 or 13 digits")
  else Yocaml.Data.Validation.fail_with ~given:str "Invalid ISBN"
;;

let from_data =
  let open Yocaml.Data.Validation in
  string & from_string
;;

let url isbn =
  "isbnsearch.org"
  |> Url.https
  |> Url.resolve (Yocaml.Path.abs [ "isbn"; value isbn ])
;;

let to_data ({ value; kind } as isbn) =
  let open Yocaml.Data in
  record
    [ "value", string value
    ; ( "kind"
      , int
          (match kind with
           | T10 -> 10
           | T13 -> 13) )
    ; "repr", isbn |> to_string |> string
    ; "target", isbn |> url |> Url.to_data
    ]
;;

module Orderable = struct
  type nonrec t = t

  let compare = compare
  let to_data = to_data
  let from_data = from_data
end

include Make.Enumerable (Orderable)
