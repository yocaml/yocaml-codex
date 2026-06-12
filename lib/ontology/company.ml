type t =
  { name : string
  ; description : string option
  ; small_logo : Scoped_url.t option
  ; large_logo : Scoped_url.t option
  ; cover : Media.t option
  ; email : Email.t option
  ; emails : Email.Set.t
  ; url : Url.t option
  ; urls : Url.Set.t
  ; social_accounts : Social_account.Set.t
  }

let make
      ?description
      ?small_logo
      ?large_logo
      ?cover
      ?email
      ?(emails = Email.Set.empty)
      ?url
      ?(urls = Url.Set.empty)
      ?(social_accounts = Social_account.Set.empty)
      name
  =
  { name
  ; description
  ; small_logo
  ; large_logo
  ; cover
  ; email
  ; emails
  ; url
  ; urls
  ; social_accounts
  }
;;

let from_name =
  let open Yocaml.Data.Validation in
  Ext.Misc.as_name $ fun name -> make name
;;

let from_mailbox =
  let open Yocaml.Data.Validation in
  (string & Email.from_mailbox) $ fun (name, email) -> make ~email name
;;

let from_record =
  let open Yocaml.Data.Validation in
  record (fun h ->
    let+ name =
      req h "name" ~alt:[ "title"; "identifier"; "ident" ] Ext.Misc.as_name
    and+ description = opt h "description" ~alt:[ "desc"; "synopsis" ] string
    and+ small_logo = opt h "small_logo" ~alt:[ "avatar" ] Scoped_url.from_data
    and+ large_logo =
      opt h "large_logo" ~alt:[ "logo"; "big_logo" ] Scoped_url.from_data
    and+ cover = opt h "cover" ~alt:[ "banner"; "hero" ] Media.from_data
    and+ email = opt h "email" ~alt:[ "mail" ] Email.from_data
    and+ emails =
      opt
        h
        "emails"
        ~alt:[ "other_emails"; "mails"; "other_mails" ]
        Email.Set.from_data
    and+ url = opt h "url" ~alt:[ "www"; "site"; "homepage" ] Url.from_data
    and+ urls =
      opt
        h
        "urls"
        ~alt:[ "other_urls"; "homepages"; "other_www" ]
        Url.Set.from_data
    and+ social_accounts =
      opt
        h
        "social_accounts"
        ~alt:[ "socials"; "accounts" ]
        Social_account.Set.from_data
    in
    make
      ?description
      ?small_logo
      ?large_logo
      ?cover
      ?email
      ?emails
      ?url
      ?urls
      ?social_accounts
      name)
;;

let from_data =
  let open Yocaml.Data.Validation in
  from_record / from_mailbox / from_name
;;

let to_data
      { name
      ; description
      ; small_logo
      ; large_logo
      ; cover
      ; email
      ; emails
      ; url
      ; urls
      ; social_accounts
      }
  =
  let email, other_emails, all_emails =
    Set.collapse_with_option (module Email.Set) emails email
  in
  let url, other_urls, all_urls =
    Set.collapse_with_option (module Url.Set) urls url
  in
  let logo = Ext.Option.(large_logo <|> small_logo) in
  let open Yocaml.Data in
  record
    [ "name", string name
    ; "description", option string description
    ; "small_logo", option Scoped_url.to_data small_logo
    ; "large_logo", option Scoped_url.to_data large_logo
    ; "logo", option Scoped_url.to_data logo
    ; "cover", option Media.to_data cover
    ; "url", option Url.to_data url
    ; "email", option Email.to_data email
    ; "other_emails", Email.Set.to_data other_emails
    ; "all_emails", Email.Set.to_data all_emails
    ; "other_urls", Url.Set.to_data other_urls
    ; "all_urls", Url.Set.to_data all_urls
    ; "social_accounts", Social_account.Set.to_data social_accounts
    ; "has_email", bool @@ Ext.Option.to_bool email
    ; "has_url", bool @@ Ext.Option.to_bool url
    ; "has_description", bool @@ Ext.Option.to_bool description
    ; "has_small_logo", bool @@ Ext.Option.to_bool small_logo
    ; "has_large_logo", bool @@ Ext.Option.to_bool large_logo
    ; "has_logo", bool @@ Ext.Option.to_bool large_logo
    ]
;;

let compare { name; _ } { name = b; _ } = String.compare name b

module Orderable = struct
  type nonrec t = t

  let compare = compare
  let to_data = to_data
  let from_data = from_data
end

include Make.Enumerable (Orderable)
