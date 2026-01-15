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
