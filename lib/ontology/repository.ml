module Path = Yocaml.Path

type org =
  { name : string
  ; project : string
  }

type provider =
  | Github of string
  | Gitlab of string
  | Gitlab_org of org
  | Tangled of string
  | Sourcehut of string
  | Codeberg of string

type t =
  | Known of
      { provider : provider
      ; bug_tracker : Url.t Derivable.opt
      ; releases : Url.t Derivable.opt
      ; repository : string
      }
  | Unknown of
      { repository : string
      ; home : Url.t
      ; bug_tracker : Url.t option
      ; releases : Url.t option
      ; blob : Url.t
      ; kind : string option
      ; default_branch : string
      }

let github
      ?(bug_tracker = `Derived)
      ?(releases = `Derived)
      ~username
      ~repository
      ()
  =
  Known { provider = Github username; repository; bug_tracker; releases }
;;

let gitlab
      ?(bug_tracker = `Derived)
      ?(releases = `Derived)
      ~username
      ~repository
      ()
  =
  Known { provider = Gitlab username; repository; bug_tracker; releases }
;;

let tangled
      ?(bug_tracker = `Derived)
      ?(releases = `Derived)
      ~username
      ~repository
      ()
  =
  Known { provider = Tangled username; repository; bug_tracker; releases }
;;

let sourcehut
      ?(bug_tracker = `Derived)
      ?(releases = `Derived)
      ~username
      ~repository
      ()
  =
  Known { provider = Sourcehut username; repository; bug_tracker; releases }
;;

let codeberg
      ?(bug_tracker = `Derived)
      ?(releases = `Derived)
      ~username
      ~repository
      ()
  =
  Known { provider = Codeberg username; repository; bug_tracker; releases }
;;

let gitlab_org
      ?(bug_tracker = `Derived)
      ?(releases = `Derived)
      ~name
      ~project
      ~repository
      ()
  =
  Known
    { provider = Gitlab_org { name; project }
    ; repository
    ; bug_tracker
    ; releases
    }
;;

let make
      ?kind
      ?(default_branch = "main")
      ?bug_tracker
      ?releases
      ~repository
      ~home
      ~blob
      ()
  =
  Unknown
    { repository; home; bug_tracker; blob; releases; kind; default_branch }
;;

let name = function
  | Unknown { repository; _ } | Known { repository; _ } -> repository
;;

let provider_base_url = function
  | Github _ -> Url.https "github.com"
  | Gitlab _ | Gitlab_org _ -> Url.https "gitlab.com"
  | Tangled _ -> Url.https "tangled.sh"
  | Sourcehut _ -> Url.https "sr.ht"
  | Codeberg _ -> Url.https "codeberg.org"
;;

let account provider =
  let base = provider_base_url provider in
  match provider with
  | Github username | Codeberg username | Gitlab username | Tangled username ->
    Url.resolve (Path.abs [ username ]) base
  | Sourcehut username ->
    Url.resolve (Path.abs [ "~" ^ username ]) (Url.https "git.sr.ht")
  | Gitlab_org { name; project } ->
    Url.resolve (Path.abs [ name; project ]) base
;;

let home provider repository =
  account provider |> Url.resolve (Path.rel [ repository ])
;;

let homepage = function
  | Unknown { home; _ } -> home
  | Known { provider; repository; _ } -> home provider repository
;;

let bug_tracker = function
  | Unknown { bug_tracker; _ } -> bug_tracker
  | Known { bug_tracker; provider; repository; _ } ->
    Derivable.resolve_opt
      (fun () ->
         let home, fragment =
           match provider with
           | Sourcehut user ->
             Url.https "todo.sr.ht", Path.abs [ "~" ^ user; repository ]
           | Gitlab _ | Gitlab_org _ ->
             home provider repository, Path.rel [ "-"; "issues" ]
           | Github _ | Tangled _ | Codeberg _ ->
             home provider repository, Path.rel [ "issues" ]
         in
         Some (Url.resolve fragment home))
      bug_tracker
;;

let releases = function
  | Unknown { releases; _ } -> releases
  | Known { releases; provider; repository; _ } ->
    Derivable.resolve_opt
      (fun () ->
         let fragment =
           match provider with
           | Gitlab _ | Gitlab_org _ -> Path.rel [ "-"; "releases" ]
           | Tangled _ -> Path.rel [ "tags" ]
           | Sourcehut _ -> Path.rel [ "refs" ]
           | Github _ | Codeberg _ -> Path.rel [ "releases" ]
         in
         Some (Url.resolve fragment (home provider repository)))
      releases
;;

let tree_or_blob flag = if flag then "blob" else "tree"

let default_branch = function
  | Sourcehut _ -> "master"
  | Github _ | Gitlab _ | Gitlab_org _ | Tangled _ | Codeberg _ -> "main"
;;

let blob_provider is_file branch path provider repository =
  let home = home provider repository in
  let branch =
    match branch with
    | Some x -> x
    | None -> default_branch provider
  in
  let root =
    match provider with
    | Github _ | Tangled _ -> Path.rel [ tree_or_blob is_file; branch ]
    | Sourcehut _ -> Path.rel [ "tree"; branch; "item" ]
    | Gitlab _ | Gitlab_org _ -> Path.rel [ "-"; tree_or_blob is_file; branch ]
    | Codeberg _ -> Path.rel [ "src"; "branch"; branch ]
  in
  home |> Url.resolve root |> Url.resolve path
;;

let resolve ?(is_file = true) ?branch path = function
  | Unknown { blob; default_branch; _ } ->
    blob
    |> Url.resolve (Path.rel [ Option.value ~default:default_branch branch ])
    |> Url.resolve path
  | Known { provider; repository; _ } ->
    blob_provider is_file branch path provider repository
;;

let kind_from_provider = function
  | Github _ -> "github"
  | Gitlab _ | Gitlab_org _ -> "gitlab"
  | Tangled _ -> "tangled"
  | Sourcehut _ -> "sourcehut"
  | Codeberg _ -> "codeberg"
;;

let kind = function
  | Unknown { kind; _ } -> Option.value ~default:"custom" kind
  | Known { provider; _ } -> kind_from_provider provider
;;

let to_data repo =
  let open Yocaml.Data in
  let home = homepage repo in
  let bug_tracker = bug_tracker repo in
  let releases = releases repo in
  let blob_root = resolve Path.cwd repo in
  record
    [ "name", string @@ name repo
    ; "kind", string @@ kind repo
    ; ( "pages"
      , record
          [ "home", Url.to_data home
          ; "bug_tracker", option Url.to_data bug_tracker
          ; "releases", option Url.to_data releases
          ; "blob_root", Url.to_data blob_root
          ; "has_bug_tracker", bool @@ Option.is_some bug_tracker
          ; "has_releases", bool @@ Option.is_some releases
          ] )
    ]
;;
