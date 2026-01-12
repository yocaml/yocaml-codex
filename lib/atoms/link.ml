type t =
  { name : string
  ; url : Url.t
  ; description : string option
  }

let make ?name ?description url =
  let name =
    match name with
    | None -> Url.name url
    | Some name -> name
  in
  { name; url; description }
;;

let from_record =
  let open Yocaml.Data.Validation in
  record (fun o ->
    let+ name =
      field o.${"name"} (option (string & String.not_blank))
      |? field o.${"title"} (option (string & String.not_blank))
    and+ description =
      field o.${"description"} (option (string & String.not_blank))
      |? field o.${"desc"} (option (string & String.not_blank))
      |? field o.${"alt"} (option (string & String.not_blank))
    and+ url =
      field o.${"url"} (option Url.from_data)
      $? field o.${"target"} Url.from_data
    in
    make ?name ?description url)
;;

let from_data =
  let open Yocaml.Data.Validation in
  from_record / (Url.from_data $ make)
;;

let to_data { name; url; description } =
  let open Yocaml.Data in
  record
    [ "name", string name
    ; "url", Url.to_data url
    ; "target", string @@ Url.to_string url
    ; "description", option string description
    ; "has_description", bool @@ Option.is_some description
    ]
;;

let compare { name; url; description } b =
  let cmp = String.compare name b.name in
  if Int.equal cmp 0
  then (
    let cmp = Url.compare url b.url in
    if Int.equal cmp 0
    then Stdlib.Option.compare String.compare description b.description
    else cmp)
  else cmp
;;

let equal { name; url; description } b =
  String.equal name b.name
  && Url.equal url b.url
  && Option.equal String.equal description b.description
;;

module Orderable = struct
  type nonrec t = t

  let compare = compare
  let to_data = to_data
  let from_data = from_data
end

module Set = struct
  module S = Stdlib.Set.Make (Orderable)
  include S
  include Set.Make (S) (Orderable) (Orderable)
end

module Map = struct
  module S = Stdlib.Map.Make (Orderable)
  include S
  include Map.Make (S) (Orderable) (Orderable)
end
