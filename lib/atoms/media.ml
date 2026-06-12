type kind =
  | Image
  | Video

type t =
  { kind : kind
  ; url : Scoped_url.t
  ; secure_url : Url.t option
  ; mime_type : string option
  ; dimension : (int * int) option
  ; alt : string option
  }

let make ~kind ?secure_url ?mime_type ?dimension ?alt url =
  { kind; url; secure_url; mime_type; dimension; alt }
;;

let image = make ~kind:Image
let video = make ~kind:Video
let compare a b = Scoped_url.compare a.url b.url

let kind_to_string = function
  | Image -> "image"
  | Video -> "video"
;;

let kind_from_data =
  let open Yocaml.Data.Validation in
  string $ String.trim $ String.lowercase_ascii
  & String.one_of [ "video"; "image" ]
    $ function
    | "video" -> Video
    | _ -> Image
;;

let from_data =
  let open Yocaml.Data.Validation in
  (Scoped_url.from_data $ make ~kind:Image)
  / record (fun fields ->
    let+ kind = req fields "kind" kind_from_data
    and+ url = req fields "url" Scoped_url.from_data
    and+ mime_type =
      opt fields "type" ~alt:[ "mime_type" ] (string & String.not_blank)
    and+ width = opt fields "width" ~alt:[ "w" ] (int & positive)
    and+ height = opt fields "height" ~alt:[ "h" ] (int & positive)
    and+ secure_url = opt fields "secure_url" Url.from_data
    and+ alt = opt fields "alt" (string & String.not_blank) in
    let dimension = Ext.Option.((fun x y -> x, y) <$> width <*> height) in
    make ~kind ?mime_type ?dimension ?secure_url ?alt url)
;;

let to_data { kind; url; secure_url; mime_type; dimension; alt } =
  let open Yocaml.Data in
  record
    [ "kind", string (kind_to_string kind)
    ; "url", Scoped_url.to_data url
    ; "secure_url", option Url.to_data secure_url
    ; "mime_type", option string mime_type
    ; "width", option (fun (w, _) -> int w) dimension
    ; "height", option (fun (_, h) -> int h) dimension
    ; "alt", option string alt
    ]
;;

module Orderable = struct
  type nonrec t = t

  let compare = compare
  let to_data = to_data
  let from_data = from_data
end

include Make.Enumerable (Orderable)

let to_open_graph { kind; url; secure_url; mime_type; dimension; alt } =
  let k = kind_to_string kind in
  let name = [ "og"; k ] in
  let mk x = name @ [ x ] in
  [ Meta.make ~name (Scoped_url.to_string url)
  ; Meta.from_opt ~name:(mk "secure_url") Url.to_string secure_url
  ; Meta.from_opt ~name:(mk "type") Fun.id mime_type
  ; Meta.from_opt ~name:(mk "width") (fun (w, _) -> string_of_int w) dimension
  ; Meta.from_opt ~name:(mk "height") (fun (_, h) -> string_of_int h) dimension
  ; Meta.from_opt ~name:(mk "alt") Fun.id alt
  ]
;;
