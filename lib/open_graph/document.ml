open Codex_atoms

type t =
  { kind : Kind.t
  ; title : string
  ; site_name : string
  ; locale : Language.t option
  ; url : Url.t
  ; cover : Media.t option
  }

let kind { kind; _ } = kind
let title { title; _ } = title
let site_name { site_name; _ } = site_name
let locale { locale; _ } = locale
let url { url; _ } = url
let cover { cover; _ } = cover

let make ?locale ?cover ~kind ~title ~site_name ~url () =
  { locale; cover; kind; title; site_name; url }
;;

let to_open_graph { kind; title; site_name; locale; url; cover } =
  let cover =
    match cover with
    | None -> []
    | Some cover -> Media.to_open_graph cover
  in
  let open Meta in
  [ make ~name:[ "og"; "title" ] title
  ; make ~name:[ "og"; "site_name" ] site_name
  ; make ~name:[ "og"; "url" ] (Url.to_string url)
  ; from_opt ~name:[ "og"; "locale" ] Language.to_string locale
  ]
  @ Kind.to_open_graph kind
  @ cover
;;
