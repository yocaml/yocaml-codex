type t =
  { display_name : string
  ; first_name : string option
  ; last_name : string option
  ; gender : Gender.t option
  ; email : Email.Zero_or_more.t
  ; url : Url.Zero_or_more.t
  ; bio : string option
  ; avatar : Scoped_url.t option
  ; birthday : Yocaml.Datetime.t option
  ; social_accounts : Social_account.Set.t
  ; company : Company.Zero_or_more.t
  }

let compare { display_name; email; _ } other =
  (* HACK: the comparison seems a little bit lax here. But for the moment I
     think it is sufficient. *)
  let c = String.compare display_name other.display_name in
  if Int.equal c 0
  then
    Option.compare
      Email.compare
      (Email.Zero_or_more.main email)
      (Email.Zero_or_more.main other.email)
  else c
;;

let make
      ?gender
      ?first_name
      ?last_name
      ?(email = Email.Zero_or_more.empty)
      ?(url = Url.Zero_or_more.empty)
      ?bio
      ?avatar
      ?birthday
      ?(social_accounts = Social_account.Set.empty)
      ?(company = Company.Zero_or_more.empty)
      display_name
  =
  { display_name
  ; first_name
  ; last_name
  ; gender
  ; email
  ; url
  ; bio
  ; avatar
  ; birthday
  ; social_accounts
  ; company
  }
;;

let display_name { display_name; _ } = display_name
let first_name { first_name; _ } = first_name
let last_name { last_name; _ } = last_name
let gender { gender; _ } = gender
let bio { bio; _ } = bio
let avatar { avatar; _ } = avatar
let birthday { birthday; _ } = birthday
let social_accounts { social_accounts; _ } = social_accounts
let email { email; _ } = email
let url { url; _ } = url
let company { company; _ } = company

let to_syndication inv =
  let uri = Option.map Url.to_string (Url.Zero_or_more.main inv.url) in
  let email = Option.map Email.to_string (Email.Zero_or_more.main inv.email) in
  Yocaml_syndication.Person.make ?uri ?email inv.display_name
;;

let to_data
      { display_name
      ; first_name
      ; last_name
      ; gender
      ; email
      ; url
      ; bio
      ; avatar
      ; birthday
      ; social_accounts
      ; company
      }
  =
  let open Yocaml.Data in
  let names = Ext.Option.zip first_name last_name in
  record
    [ "display_name", string display_name
    ; "bio", Ext.Option.to_data string bio
    ; "slug", string (Yocaml.Slug.from display_name)
    ; "first_name", Ext.Option.to_data string first_name
    ; "last_name", Ext.Option.to_data string last_name
    ; "gender", Ext.Option.to_data Gender.to_data gender
    ; "avatar", Ext.Option.to_data Scoped_url.to_data avatar
    ; "birthday", Ext.Option.to_data Yocaml.Datetime.to_data birthday
    ; "email", Email.Zero_or_more.to_data email
    ; "url", Url.Zero_or_more.to_data url
    ; "social_accounts", Social_account.Set.to_data social_accounts
    ; "company", Company.Zero_or_more.to_data company
    ; ( "with_names"
      , Ext.Option.to_data
          (fun (first_name, last_name) ->
             (* Should be safe because of `Ext.Misc.as_name` that guards
                names of length > 1. *)
             let ff = first_name.[0] |> Ext.String.from_char
             and fl = last_name.[0] |> Ext.String.from_char in
             let initials = ff ^ fl |> String.lowercase_ascii
             and display = (ff |> String.uppercase_ascii) ^ ". " ^ last_name in
             record [ "initials", string initials; "display", string display ])
          names )
    ]
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
      Ext.Misc.as_name
  and+ first_name =
    opt
      fields
      "first_name"
      ~alt:
        [ "given_name"; "firstname"; "forename"; "fname"; "givenname"; "gname" ]
      Ext.Misc.as_name
  and+ last_name =
    opt fields "last_name" ~alt:[ "lastname"; "lname" ] Ext.Misc.as_name
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
  & fun (name, email) ->
  from_string ~email:(Email.Zero_or_more.one email) (Yocaml.Data.string name)
;;

let from_record =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let+ display_name, first_name, last_name =
      (validate_name & from_triple) fields
    and+ email =
      opt
        fields
        "email"
        ~alt:[ "mail"; "emails"; "mails" ]
        Email.Zero_or_more.from_data
    and+ url =
      opt
        fields
        "url"
        ~alt:[ "www"; "site"; "homepage"; "urls"; "links"; "link" ]
        Url.Zero_or_more.from_data
    and+ bio =
      opt
        fields
        "bio"
        ~alt:[ "biography"; "synopsis"; "desc"; "description" ]
        Ext.Misc.as_name
    and+ gender = opt fields "gender" Gender.from_data
    and+ avatar =
      opt
        fields
        "avatar"
        ~alt:[ "profile_picture"; "picture" ]
        Scoped_url.from_data
    and+ birthday =
      opt
        fields
        "birthday"
        ~alt:[ "birth"; "birthdate" ]
        Yocaml.Datetime.from_data
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
      ?url
      ?last_name
      ?bio
      ?social_accounts
      ?avatar
      ?birthday
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

include Make.Enumerable (Orderable)

let to_meta { display_name; _ } =
  Codex_atoms.Meta.make ~name:[ "author" ] display_name
;;

let to_open_graph { display_name; first_name; last_name; gender; _ } =
  Codex_open_graph.Kind.profile
    ?first_name
    ?last_name
    ?gender
    ~username:display_name
    ()
;;
