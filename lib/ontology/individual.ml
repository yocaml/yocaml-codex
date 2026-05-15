type t =
  { display_name : string
  ; first_name : string option
  ; last_name : string option
  ; gender : Gender.t option
  ; email : Email.t option
  }

let compare { display_name; email; _ } other =
  (* HACK: the comparison seems a little bit lax here. But for the moment I
     think it is sufficient. *)
  let c = String.compare display_name other.display_name in
  if Int.equal c 0 then Option.compare Email.compare email other.email else c
;;

let make ?gender ?first_name ?last_name ?email display_name =
  { display_name; first_name; last_name; gender; email }
;;

let to_syndication inv = Yocaml_syndication.Person.make inv.display_name

let to_data { display_name; first_name; last_name; gender; email } =
  let open Yocaml.Data in
  let names = Ext.Option.zip first_name last_name in
  record
    [ "display_name", string display_name
    ; "slug", string (Yocaml.Slug.from display_name)
    ; "first_name", option string first_name
    ; "last_name", option string last_name
    ; "email", option Email.to_data email
    ; "gender", option Gender.to_data gender
    ; "has_first_name", bool @@ Ext.Option.to_bool first_name
    ; "has_last_name", bool @@ Ext.Option.to_bool last_name
    ; "has_email", bool @@ Ext.Option.to_bool email
    ; "has_names", bool @@ Ext.Option.to_bool names
    ; "has_gender", bool @@ Ext.Option.to_bool gender
    ; ( "with_names"
      , option
          (fun (first_name, last_name) ->
             (* Should be safe because of `as_name` that guards
                names of length > 1. *)
             let ff = first_name.[0] |> Ext.String.from_char
             and fl = last_name.[0] |> Ext.String.from_char in
             let initials = ff ^ fl |> String.lowercase_ascii
             and display = (ff |> String.uppercase_ascii) ^ ". " ^ last_name in
             record [ "initials", string initials; "display", string display ])
          names )
    ]
;;

let as_name =
  let open Yocaml.Data.Validation in
  string $ String.trim & String.not_blank & String.length_gt 1
;;

let missing_display_name =
  let error =
    Yocaml.Data.Validation.Missing_field { field = "display_name" }
    |> Yocaml.Nel.singleton
  in
  Error error
;;

let from_triple = function
  | Some a, Some b, Some c -> Ok (a, Some (String.capitalize_ascii b), Some c)
  | None, Some b, Some c ->
    let b = String.capitalize_ascii b in
    let a = b ^ " " ^ c in
    Ok (a, Some b, Some c)
  | Some a, b, c -> Ok (a, b, c)
  | _ -> missing_display_name
;;

let from_string_to_triple s =
  (* Read name as "first-name/display_name/last_name". *)
  match String.split_on_char '/' s |> List.map String.trim with
  | [ first_name; display_name; last_name ] ->
    Ok
      Yocaml.Data.(
        record
          [ "display_name", string display_name
          ; "first_name", string first_name
          ; "last_name", string last_name
          ])
  | _ ->
    (* Read name as "display_name" or "first-name last-name". *)
    (match
       s
       |> String.split_on_char ' '
       |> List.filter_map (fun x ->
         match String.trim x with
         | "" -> None
         | x -> Some x)
     with
     | [] -> Ok (Yocaml.Data.record [])
     | x :: [] -> Ok Yocaml.Data.(record [ "display_name", string x ])
     | x :: xs ->
       Ok
         Yocaml.Data.(
           record
             [ "first_name", string x
             ; "last_name", string @@ String.concat " " xs
             ]))
;;

let validate_name fields =
  let open Yocaml.Data.Validation in
  let+ display_name =
    opt
      fields
      "display_name"
      ~alt:
        [ "nick"
        ; "nickname"
        ; "user"
        ; "username"
        ; "displayname"
        ; "name"
        ; "designation"
        ; "denotation"
        ; "alias"
        ; "aka"
        ; "cognomen"
        ; "handle"
        ; "dname"
        ]
      as_name
  and+ first_name =
    opt
      fields
      "first_name"
      ~alt:
        [ "given_name"; "firstname"; "forename"; "fname"; "givenname"; "gname" ]
      as_name
  and+ last_name =
    opt fields "last_name" ~alt:[ "lastname"; "lname" ] as_name
  in
  display_name, first_name, last_name
;;

let from_string =
  let open Yocaml.Data.Validation in
  string
  & ((from_string_to_triple
      & record (validate_name & from_triple)
        $ fun (display_name, first_name, last_name) ->
        make ?first_name ?last_name display_name)
     / fun x -> Ok (make x))
;;

let from_mailbox =
  let open Yocaml.Data.Validation in
  (string & Email.from_mailbox) $ fun (name, email) -> make ~email name
;;

let from_record =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let+ display_name, first_name, last_name =
      (validate_name & from_triple) fields
    and+ email = opt fields "email" ~alt:[ "mail" ] Email.from_data
    and+ gender = opt fields "gender" Gender.from_data in
    make ?gender ?first_name ?email ?last_name display_name)
;;

let from_data =
  let open Yocaml.Data.Validation in
  from_mailbox / from_string / from_record
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

let to_meta authors =
  authors
  |> Set.to_list
  |> List.map (fun { display_name; _ } ->
    Codex_atoms.Meta.make ~name:[ "creator" ] display_name)
;;
