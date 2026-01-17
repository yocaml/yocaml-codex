type provider =
  | Github of string
  | Gitlab of string
  | Codeberg of string
  | Sourcehut of string
  | X of string
  | Bluesky of string
  | Mastodon of
      { instance : Url.t
      ; username : string
      }
  | Linkedin of string
  | Instagram of string
  | Facebook of string
  | Threads of string
  | Cara of string

type t =
  | Known of provider
  | Unknown of
      { url : Url.t
      ; username : string
      ; kind : string option
      }

let make ?kind ~url ~username () = Unknown { url; username; kind }
let mastodon ~instance ~username () = Known (Mastodon { instance; username })
let github ~username () = Known (Github username)
let gitlab ~username () = Known (Gitlab username)
let codeberg ~username () = Known (Codeberg username)
let sourcehut ~username () = Known (Sourcehut username)
let x ~username () = Known (X username)
let bluesky ~username () = Known (Bluesky username)
let linkedin ~username () = Known (Linkedin username)
let instagram ~username () = Known (Instagram username)
let facebook ~username () = Known (Facebook username)
let threads ~username () = Known (Threads username)
let cara ~username () = Known (Cara username)
let twitter = x
let bsky = bluesky

let known = function
  | Known _ -> true
  | Unknown _ -> false
;;

let kind_from_provider = function
  | Github _ -> "github"
  | Gitlab _ -> "gitlab"
  | Codeberg _ -> "codeberg"
  | Sourcehut _ -> "sourcehut"
  | X _ -> "x"
  | Bluesky _ -> "bluesky"
  | Mastodon _ -> "mastodon"
  | Linkedin _ -> "linkedin"
  | Instagram _ -> "instagram"
  | Cara _ -> "cara"
  | Facebook _ -> "facebook"
  | Threads _ -> "threads"
;;

let kind = function
  | Unknown { kind; _ } -> Option.value ~default:"custom" kind
  | Known provider -> kind_from_provider provider
;;

let username_from_provider = function
  | Github username
  | Gitlab username
  | Codeberg username
  | Sourcehut username
  | X username
  | Bluesky username
  | Linkedin username
  | Instagram username
  | Cara username
  | Facebook username
  | Threads username -> username
  | Mastodon { instance; username } ->
    let instance = Url.name ~with_scheme:false ~with_path:false instance in
    instance ^ "/" ^ username
;;

let username = function
  | Unknown { username; _ } -> username
  | Known provider -> username_from_provider provider
;;

let domain_from_provider = function
  | Github _ -> Url.https "github.com"
  | Gitlab _ -> Url.https "gitlab.com"
  | Codeberg _ -> Url.https "codeberg.org"
  | Sourcehut _ -> Url.https "sr.ht"
  | X _ -> Url.https "x.com"
  | Bluesky _ -> Url.https "bsky.app"
  | Mastodon { instance; _ } -> instance
  | Linkedin _ -> Url.https "linkedin.com"
  | Instagram _ -> Url.https "instagram.com"
  | Facebook _ -> Url.https "facebook.com"
  | Threads _ -> Url.https "threads.com"
  | Cara _ -> Url.https "cara.app"
;;

let domain = function
  | Unknown { url; _ } -> Url.resolve Yocaml.Path.root url
  | Known provider -> domain_from_provider provider
;;

let url_from_provider provider =
  let domain = domain_from_provider provider in
  match provider with
  | Github username
  | Gitlab username
  | Codeberg username
  | X username
  | Instagram username
  | Facebook username
  | Cara username -> Url.resolve Yocaml.Path.(rel [ username ]) domain
  | Sourcehut username ->
    Url.resolve Yocaml.Path.(rel [ Ext.String.may_prepend '~' username ]) domain
  | Threads username | Mastodon { username; _ } ->
    Url.resolve Yocaml.Path.(rel [ Ext.String.may_prepend '@' username ]) domain
  | Linkedin username -> Url.resolve Yocaml.Path.(rel [ "in"; username ]) domain
  | Bluesky username ->
    Url.resolve Yocaml.Path.(rel [ "profile"; username ]) domain
;;

let url = function
  | Unknown { url; _ } -> url
  | Known provider -> url_from_provider provider
;;

let to_data account =
  let open Yocaml.Data in
  let kind = kind account
  and domain = domain account
  and known = known account
  and username = username account
  and url = url account in
  record
    [ "kind", string kind
    ; "is_known", bool known
    ; "is_custom", bool (not known)
    ; "username", string username
    ; "domain", Url.to_data domain
    ; "url", Url.to_data url
    ]
;;

module Validation = struct
  let github_kind = [ "github.com"; "github"; "gh" ]
  let gitlab_kind = [ "gitlab.com"; "gitlab"; "gl" ]
  let codeberg_kind = [ "codeberg.org"; "codeberg"; "cb" ]

  let sourcehut_kind =
    [ "sourcehut.org"; "sr.ht"; "git.sr.ht"; "sourcehut"; "sr" ]
  ;;

  let x_kind = [ "x.com"; "twitter.com"; "x"; "twitter" ]
  let bluesky_kind = [ "bsky.app"; "bluesky"; "bsky" ]
  let linkedin_kind = [ "linkedin.com"; "linkedin" ]
  let instagram_kind = [ "instagram.com"; "instagram"; "insta"; "ig" ]
  let facebook_kind = [ "facebook.com"; "facebook"; "fb" ]
  let cara_kind = [ "cara.app"; "cara" ]
  let threads_kind = [ "threads.com"; "threads" ]

  let all_kind =
    github_kind
    @ gitlab_kind
    @ codeberg_kind
    @ sourcehut_kind
    @ x_kind
    @ bluesky_kind
    @ linkedin_kind
    @ instagram_kind
    @ facebook_kind
    @ cara_kind
    @ threads_kind
  ;;

  let in_enum = Ext.Misc.in_str_enum ~case_sensitive:false

  let kind_enum =
    let open Yocaml.Data.Validation in
    (string $ fun x -> x |> Stdlib.String.trim |> Stdlib.String.lowercase_ascii)
    & String.one_of ~case_sensitive:false all_kind
    & fun k ->
    if in_enum github_kind k
    then Ok `Github
    else if in_enum gitlab_kind k
    then Ok `Gitlab
    else if in_enum codeberg_kind k
    then Ok `Codeberg
    else if in_enum sourcehut_kind k
    then Ok `Sourcehut
    else if in_enum x_kind k
    then Ok `X
    else if in_enum bluesky_kind k
    then Ok `Bluesky
    else if in_enum linkedin_kind k
    then Ok `Linkedin
    else if in_enum instagram_kind k
    then Ok `Instagram
    else if in_enum facebook_kind k
    then Ok `Facebook
    else if in_enum cara_kind k
    then Ok `Cara
    else if in_enum threads_kind k
    then Ok `Threads
    else fail_with ~given:k "Invalid social media account provider"
  ;;

  let on_kind f v fields =
    f ?alt:(Some [ "platform"; "network" ]) fields "kind" v
  ;;

  let required_kind = on_kind Yocaml.Data.Validation.req kind_enum

  let optional_kind =
    on_kind Yocaml.Data.Validation.opt Yocaml.Data.Validation.string
  ;;

  let mastodon_from_string =
    let open Yocaml.Data.Validation in
    string
    & String.has_prefix ~prefix:"@" $ Ext.String.remove_leading_arobase
    & fun str ->
    match Stdlib.String.split_on_char '@' str with
    | [ instance; username ] ->
      let instance = Url.https instance in
      Ok (mastodon ~instance ~username ())
    | _ -> fail_with ~given:str "Not a mastodon account"
  ;;

  let required_username fields =
    Yocaml.Data.Validation.req
      fields
      "username"
      ~alt:[ "user"; "profile"; "id"; "ident" ]
      Ext.Misc.as_name
  ;;

  let mastodon_from_record =
    let open Yocaml.Data.Validation in
    record (fun fields ->
      let+ instance = req fields "instance" Url.from_data
      and+ username = required_username fields in
      mastodon ~instance ~username ())
  ;;

  let mastodon =
    let open Yocaml.Data.Validation in
    mastodon_from_string / mastodon_from_record
  ;;

  let record_from_path ?kind social_path =
    let open Yocaml.Data in
    let k = "kind", option string kind in
    let opt_k =
      Option.map (fun x -> Stdlib.String.(trim @@ lowercase_ascii x)) kind
    in
    match Ext.Misc.ltrim_path social_path with
    | user :: ([ "" ] | []) -> k :: [ "username", string user ] |> record
    | instance :: user :: ([ "" ] | [])
      when Option.equal String.equal opt_k (Some "mastodon") ->
      record [ "instance", string instance; "username", string user ]
    | _ -> record [ k ]
  ;;

  let from_known_record =
    let open Yocaml.Data.Validation in
    mastodon_from_record
    / record (fun fields ->
      let+ kind = required_kind fields
      and+ username = required_username fields in
      let make =
        match kind with
        | `Github -> github
        | `Gitlab -> gitlab
        | `Codeberg -> codeberg
        | `Sourcehut -> sourcehut
        | `X -> x
        | `Bluesky -> bluesky
        | `Linkedin -> linkedin
        | `Instagram -> instagram
        | `Facebook -> facebook
        | `Cara -> cara
        | `Threads -> threads
      in
      make ~username ())
  ;;

  let from_unkown_record =
    let open Yocaml.Data.Validation in
    record (fun fields ->
      let+ kind = optional_kind fields
      and+ url = req fields "url" ~alt:[ "www"; "link" ] Url.from_data
      and+ username = required_username fields in
      make ?kind ~url ~username ())
  ;;

  let from_identifier s =
    let fields =
      match Ext.Misc.split_path s with
      | [] -> Yocaml.Data.record []
      | kind :: xs -> record_from_path ~kind xs
    in
    let open Yocaml.Data.Validation in
    (mastodon_from_record / from_known_record) fields
  ;;

  let from_string =
    let open Yocaml.Data.Validation in
    ((list_of string $ Stdlib.String.concat "/") / string) & from_identifier
  ;;
end

let from_data =
  let open Yocaml.Data.Validation in
  Validation.from_string
  / Validation.mastodon
  / Validation.from_unkown_record
  / Validation.from_known_record
;;

let compare a b =
  let a = url a
  and b = url b in
  Url.compare a b
;;

let equal a b =
  let a = url a
  and b = url b in
  Url.equal a b
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
