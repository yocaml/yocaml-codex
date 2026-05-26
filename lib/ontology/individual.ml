type t =
  { display_name : string
  ; first_name : string option
  ; last_name : string option
  ; gender : Gender.t option
  ; email : Email.t option
  ; emails : Email.Set.t
  ; url : Url.t option
  ; urls : Url.Set.t
  ; bio : string option
  ; avatar : Scoped_url.t option
  ; social_accounts : Social_account.Set.t
  }

let compare { display_name; email; _ } other =
  (* HACK: the comparison seems a little bit lax here. But for the moment I
     think it is sufficient. *)
  let c = String.compare display_name other.display_name in
  if Int.equal c 0 then Option.compare Email.compare email other.email else c
;;

let make
      ?gender
      ?first_name
      ?last_name
      ?email
      ?(emails = Email.Set.empty)
      ?url
      ?(urls = Url.Set.empty)
      ?bio
      ?avatar
      ?(social_accounts = Social_account.Set.empty)
      display_name
  =
  { display_name
  ; first_name
  ; last_name
  ; gender
  ; email
  ; emails
  ; url
  ; urls
  ; bio
  ; avatar
  ; social_accounts
  }
;;

let display_name { display_name; _ } = display_name
let first_name { first_name; _ } = first_name
let last_name { last_name; _ } = last_name
let gender { gender; _ } = gender
let bio { bio; _ } = bio
let avatar { avatar; _ } = avatar
let social_accounts { social_accounts; _ } = social_accounts

let email inv =
  let email, _, _ =
    Set.collapse_with_option (module Email.Set) inv.emails inv.email
  in
  email
;;

let url inv =
  let uri, _, _ = Set.collapse_with_option (module Url.Set) inv.urls inv.url in
  uri
;;

let all_emails { email; emails; _ } =
  let _, _, x = Set.collapse_with_option (module Email.Set) emails email in
  x
;;

let all_urls { url; urls; _ } =
  let _, _, x = Set.collapse_with_option (module Url.Set) urls url in
  x
;;

let to_syndication inv =
  let uri = Option.map Url.to_string (url inv) in
  let email = Option.map Email.to_string (email inv) in
  Yocaml_syndication.Person.make ?uri ?email inv.display_name
;;

let to_data
      { display_name
      ; first_name
      ; last_name
      ; gender
      ; email
      ; emails
      ; url
      ; urls
      ; bio
      ; avatar
      ; social_accounts
      }
  =
  let open Yocaml.Data in
  let names = Ext.Option.zip first_name last_name in
  let email, other_emails, all_emails =
    Set.collapse_with_option (module Email.Set) emails email
  in
  let url, other_urls, all_urls =
    Set.collapse_with_option (module Url.Set) urls url
  in
  record
    [ "display_name", string display_name
    ; "bio", option string bio
    ; "slug", string (Yocaml.Slug.from display_name)
    ; "first_name", option string first_name
    ; "last_name", option string last_name
    ; "gender", option Gender.to_data gender
    ; "avatar", option Scoped_url.to_data avatar
    ; "email", option Email.to_data email
    ; "url", option Url.to_data url
    ; "other_emails", Email.Set.to_data other_emails
    ; "all_emails", Email.Set.to_data all_emails
    ; "other_urls", Url.Set.to_data other_urls
    ; "all_urls", Url.Set.to_data all_urls
    ; "social_accounts", Social_account.Set.to_data social_accounts
    ; "has_bio", bool @@ Ext.Option.to_bool bio
    ; "has_first_name", bool @@ Ext.Option.to_bool first_name
    ; "has_last_name", bool @@ Ext.Option.to_bool last_name
    ; "has_email", bool @@ Ext.Option.to_bool email
    ; "has_url", bool @@ Ext.Option.to_bool url
    ; "has_names", bool @@ Ext.Option.to_bool names
    ; "has_gender", bool @@ Ext.Option.to_bool gender
    ; "has_avatar", bool @@ Ext.Option.to_bool avatar
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

let from_string ?email =
  let open Yocaml.Data.Validation in
  string
  & ((from_string_to_triple
      & record (validate_name & from_triple)
        $ fun (display_name, first_name, last_name) ->
        make ?email ?first_name ?last_name display_name)
     / fun x -> Ok (make ?email x))
;;

let from_mailbox =
  let open Yocaml.Data.Validation in
  (string & Email.from_mailbox)
  & fun (name, email) -> from_string ~email (Yocaml.Data.string name)
;;

let from_record =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let+ display_name, first_name, last_name =
      (validate_name & from_triple) fields
    and+ email = opt fields "email" ~alt:[ "mail" ] Email.from_data
    and+ emails =
      opt
        fields
        "emails"
        ~alt:[ "other_emails"; "mails"; "other_mails" ]
        Email.Set.from_data
    and+ url = opt fields "url" ~alt:[ "www"; "site"; "homepage" ] Url.from_data
    and+ urls =
      opt
        fields
        "urls"
        ~alt:[ "other_urls"; "homepages"; "other_www" ]
        Url.Set.from_data
    and+ bio =
      opt
        fields
        "bio"
        ~alt:[ "biography"; "synopsis"; "desc"; "description" ]
        as_name
    and+ gender = opt fields "gender" Gender.from_data
    and+ social_accounts =
      opt
        fields
        "social_accounts"
        ~alt:[ "socials"; "accounts" ]
        Social_account.Set.from_data
    in
    make
      ?gender
      ?first_name
      ?email
      ?emails
      ?url
      ?urls
      ?last_name
      ?bio
      ?social_accounts
      display_name)
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

let to_open_graph { display_name; first_name; last_name; gender; _ } =
  Codex_open_graph.Kind.profile ?first_name ?last_name ?gender display_name
;;
