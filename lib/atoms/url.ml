type scheme =
  | Http
  | Https
  | File
  | Other of string

type t =
  { scheme : scheme
  ; host : string
  ; port : int option
  ; path : Yocaml.Path.t
  ; query_params : string list Map.String.t
  ; uri : Uri.t
  }

let scheme_from_string = function
  | None -> Https
  | Some scheme ->
    (match String.(trim @@ lowercase_ascii scheme) with
     | "http" -> Http
     | "https" -> Https
     | "file" -> File
     | other -> Other other)
;;

let scheme_to_string = function
  | Other scheme -> String.(trim @@ lowercase_ascii scheme)
  | Http -> "http"
  | Https -> "https"
  | File -> "file"
;;

let from_uri uri =
  let host = Uri.host_with_default ~default:"localhost" uri
  and scheme = scheme_from_string @@ Uri.scheme uri
  and port = Uri.port uri
  and query_params = uri |> Uri.query |> Map.String.of_list
  and path = Yocaml.Path.from_string @@ Uri.path uri in
  { scheme; host; port; path; query_params; uri }
;;

let compare { uri = a; _ } { uri = b; _ } = Uri.compare a b
let equal { uri = a; _ } { uri = b; _ } = Uri.equal a b
let from_string url = url |> Uri.of_string |> from_uri
let to_string { uri; _ } = uri |> Uri.to_string

let to_data ({ scheme; host; port; path = uri_path; query_params; uri } as url) =
  let query_string = Uri.verbatim_query uri in
  let open Yocaml.Data in
  record
    [ "target", string @@ to_string url
    ; "scheme", string @@ scheme_to_string scheme
    ; "host", string host
    ; "port", option int port
    ; "path", path uri_path
    ; "has_port", bool @@ Option.is_some port
    ; "query_params", Map.String.to_data (list_of string) query_params
    ; "query_string", option string query_string
    ; "has_query_string", bool @@ Option.is_some query_string
    ]
;;

let from_data_string =
  let open Yocaml.Data.Validation in
  string & String.not_blank $ from_string
;;

let from_data =
  let open Yocaml.Data.Validation in
  record (fun o ->
    let+ target = required o "target" from_data_string in
    target)
  / from_data_string
;;

let resolve
      ?(on_query = `Remove)
      given_path
      ({ path; uri; query_params; _ } as url)
  =
  let path =
    match Yocaml.Path.to_pair given_path with
    | `Root, _ -> given_path
    | `Rel, _ -> Yocaml.Path.relocate ~into:path given_path
  in
  let query =
    match on_query with
    | `Remove -> []
    | `Keep query -> query
    | `Set list -> list
    | `Update f -> f (Map.String.to_list query_params)
  in
  let uri =
    Uri.with_query (Uri.with_path uri (Yocaml.Path.to_string path)) query
  in
  { url with path; uri; query_params = Map.String.of_list query }
;;

let with_scheme ~scheme ?path rest =
  let url = scheme ^ "://" ^ rest |> from_string in
  Stdlib.Option.fold ~none:url ~some:(fun path -> resolve path url) path
;;

let http = with_scheme ~scheme:"http"
let https = with_scheme ~scheme:"https"
