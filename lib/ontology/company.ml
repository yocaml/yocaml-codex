type t =
  { name : string
  ; description : string option
  ; small_logo : Scoped_url.t option
  ; large_logo : Scoped_url.t option
  ; cover : Media.t option
  ; email : Email.Zero_or_more.t
  ; url : Url.Zero_or_more.t
  ; social_accounts : Social_account.Set.t
  }

let make
      ?description
      ?small_logo
      ?large_logo
      ?cover
      ?(email = Email.Zero_or_more.empty)
      ?(url = Url.Zero_or_more.empty)
      ?(social_accounts = Social_account.Set.empty)
      name
  =
  { name
  ; description
  ; small_logo
  ; large_logo
  ; cover
  ; email
  ; url
  ; social_accounts
  }
;;

let from_name =
  let open Yocaml.Data.Validation in
  Ext.Misc.as_name $ fun name -> make name
;;

let from_mailbox =
  let open Yocaml.Data.Validation in
  (string & Email.from_mailbox)
  $ fun (name, email) -> make ~email:(Email.Zero_or_more.one email) name
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
    and+ email =
      opt
        h
        "email"
        ~alt:[ "mail"; "other_emails"; "mails"; "other_mails" ]
        Email.Zero_or_more.from_data
    and+ url =
      opt
        h
        "url"
        ~alt:
          [ "www"; "site"; "homepage"; "other_urls"; "homepages"; "other_www" ]
        Url.Zero_or_more.from_data
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
      ?url
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
      ; url
      ; social_accounts
      }
  =
  let logo = Ext.Option.(large_logo <|> small_logo) in
  let open Yocaml.Data in
  record
    [ "name", string name
    ; "description", option string description
    ; "small_logo", option Scoped_url.to_data small_logo
    ; "large_logo", option Scoped_url.to_data large_logo
    ; "logo", option Scoped_url.to_data logo
    ; "cover", option Media.to_data cover
    ; "url", Url.Zero_or_more.to_data url
    ; "email", Email.Zero_or_more.to_data email
    ; "social_accounts", Social_account.Set.to_data social_accounts
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
