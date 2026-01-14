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
  | Tangled _ -> Url.https "tangled.org"
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

let components_from_provider repository = function
  | Github username
  | Gitlab username
  | Tangled username
  | Sourcehut username
  | Codeberg username -> [ username; repository ]
  | Gitlab_org { name; project } -> [ name; project; repository ]
;;

let components repo =
  let kind = kind repo in
  let tail =
    match repo with
    | Unknown { repository; _ } -> [ repository ]
    | Known { repository; provider; _ } ->
      components_from_provider repository provider
  in
  kind :: tail
;;

let to_data repo =
  let open Yocaml.Data in
  let home = homepage repo
  and components = components repo
  and bug_tracker = bug_tracker repo
  and releases = releases repo
  and blob_root = resolve Path.cwd repo in
  let identifier = String.concat "/" components in
  record
    [ "name", string @@ name repo
    ; "kind", string @@ kind repo
    ; "components", list_of string components
    ; "identifier", string identifier
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

module Validation = struct
  let github_kind = [ "github.com"; "github"; "gh" ]
  let gitlab_kind = [ "gitlab.com"; "gitlab"; "gl" ]
  let tangled_kind = [ "tangled.org"; "tangled"; "tl" ]
  let codeberg_kind = [ "codeberg.org"; "codeberg"; "cb" ]

  let sourcehut_kind =
    [ "sourcehut.org"; "sr.ht"; "git.sr.ht"; "sourcehut"; "sr" ]
  ;;

  let all_kind =
    github_kind @ tangled_kind @ gitlab_kind @ codeberg_kind @ sourcehut_kind
  ;;

  let kind_enum =
    let open Yocaml.Data.Validation in
    (string $ fun x -> x |> Stdlib.String.trim |> Stdlib.String.lowercase_ascii)
    & String.one_of ~case_sensitive:false all_kind
    & fun k ->
    if List.exists (Stdlib.String.equal k) github_kind
    then Ok `Github
    else if List.exists (Stdlib.String.equal k) gitlab_kind
    then Ok `Gitlab
    else if List.exists (Stdlib.String.equal k) tangled_kind
    then Ok `Tangled
    else if List.exists (Stdlib.String.equal k) codeberg_kind
    then Ok `Codeberg
    else if List.exists (Stdlib.String.equal k) sourcehut_kind
    then Ok `Sourcehut
    else fail_with ~given:k "Invalid repository provider"
  ;;

  let split_path p =
    p
    |> String.split_on_char '/'
    |> List.map (fun x ->
      x
      |> Ext.String.trim_when (function
        | ' ' | '\012' | '\n' | '\r' | '\t' | '@' | '~' -> true
        | _ -> false)
      |> String.lowercase_ascii)
  ;;

  let as_name =
    let open Yocaml.Data.Validation in
    (string
     $ fun x ->
     x
     |> Stdlib.String.trim
     |> Stdlib.String.lowercase_ascii
     |> Ext.String.remove_leading_arobase)
    & String.not_blank
  ;;

  let ltrim_path = function
    | x :: xs when String.(equal (trim x)) "" -> xs
    | xs -> xs
  ;;

  let remove_dot_git s =
    match String.lowercase_ascii @@ Filename.extension s with
    | ".git" -> Filename.remove_extension s
    | _ -> s
  ;;

  let record_from_path ?kind ?releases ?bug_tracker repo_path =
    let open Yocaml.Data in
    let k = "kind", option string kind
    and releases = "releases", option Url.to_data releases
    and bug_tracker = "bug_tracker", option Url.to_data bug_tracker in
    match ltrim_path repo_path with
    | user :: repository :: ([ "" ] | []) ->
      k
      :: releases
      :: bug_tracker
      :: [ "user", string user
         ; "repository", string (remove_dot_git repository)
         ]
      |> record
    | name :: project :: repository :: ([ "" ] | [])
      when Stdlib.List.exists
             (fun x ->
                match kind with
                | None -> false
                | Some k -> Stdlib.String.equal x k)
             gitlab_kind ->
      releases
      :: bug_tracker
      :: [ "name", string name
         ; "project", string project
         ; "repository", string (remove_dot_git repository)
         ]
      |> record
    | _ -> record [ k ]
  ;;

  let required_kind fields =
    let open Yocaml.Data.Validation in
    field (fetch fields "kind") (option kind_enum)
    |? field (fetch fields "provider") (option kind_enum)
    $? field (fetch fields "forge") kind_enum
  ;;

  let required_repository o =
    let open Yocaml.Data.Validation in
    field (fetch o "repository") (option as_name)
    |? field (fetch o "name") (option as_name)
    $? field (fetch o "repo") as_name
  ;;

  let resolve_derivable_links =
    let open Yocaml.Data.Validation in
    record (fun fields ->
      let+ bug_tracker = Derivable.optional fields "bug_tracker" Url.from_data
      and+ releases = Derivable.optional fields "releases" Url.from_data in
      bug_tracker, releases)
  ;;

  let from_record_user =
    let open Yocaml.Data.Validation in
    record (fun fields ->
      let+ kind = required_kind fields
      and+ username = required fields "user" as_name
      and+ repository = required_repository fields
      and+ bug_tracker, releases = sub_record fields resolve_derivable_links in
      let make =
        match kind with
        | `Github -> github
        | `Gitlab -> gitlab
        | `Tangled -> tangled
        | `Codeberg -> codeberg
        | `Sourcehut -> sourcehut
      in
      make ~bug_tracker ~releases ~username ~repository ())
  ;;

  let from_record_org =
    let open Yocaml.Data.Validation in
    record (fun fields ->
      let+ name = required fields "name" as_name
      and+ project = required fields "project" as_name
      and+ repository = required_repository fields
      and+ bug_tracker, releases = sub_record fields resolve_derivable_links in
      gitlab_org ~bug_tracker ~releases ~name ~project ~repository ())
  ;;

  let from_known_record =
    let open Yocaml.Data.Validation in
    from_record_org / from_record_user
  ;;

  let from_unknown_record =
    let open Yocaml.Data.Validation in
    record (fun fields ->
      let+ kind = optional fields "kind" as_name
      and+ default_branch = optional fields "default_branch" as_name
      and+ bug_tracker = optional fields "bug_tracker" Url.from_data
      and+ releases = optional fields "releases" Url.from_data
      and+ repository = required_repository fields
      and+ home =
        field (fetch fields "home") (option Url.from_data)
        |? field (fetch fields "www") (option Url.from_data)
        $? field (fetch fields "homepage") Url.from_data
      and+ blob =
        field (fetch fields "blob") (option Url.from_data)
        |? field (fetch fields "root") (option Url.from_data)
        $? field (fetch fields "resolver") Url.from_data
      in
      make
        ?kind
        ?default_branch
        ?bug_tracker
        ?releases
        ~repository
        ~home
        ~blob
        ())
  ;;

  let from_uri ?releases ?bug_tracker s =
    let uri = Uri.of_string s in
    let path = uri |> Uri.path |> split_path in
    let kind = Uri.host uri in
    let fields = record_from_path ?releases ?bug_tracker ?kind path in
    from_known_record fields
  ;;

  let from_identifier ?releases ?bug_tracker s =
    let fields =
      match split_path s with
      | [] -> Yocaml.Data.record []
      | kind :: xs -> record_from_path ?releases ?bug_tracker ~kind xs
    in
    from_known_record fields
  ;;

  let from_string ?releases ?bug_tracker =
    let open Yocaml.Data.Validation in
    string
    & (from_identifier ?releases ?bug_tracker / from_uri ?releases ?bug_tracker)
  ;;

  let from_compact =
    let open Yocaml.Data.Validation in
    record (fun fields ->
      let+ bug_tracker, releases = sub_record fields resolve_derivable_links
      and+ repo =
        field (fetch fields "repository") (option string)
        |? field (fetch fields "name") (option string)
        $? field (fetch fields "repo") string
      in
      bug_tracker, releases, repo)
    & fun (bug_tracker, releases, repo) ->
    from_string
      ?releases:(Derivable.to_option releases)
      ?bug_tracker:(Derivable.to_option bug_tracker)
      (Yocaml.Data.string repo)
  ;;
end

let from_data =
  let open Yocaml.Data.Validation in
  Validation.from_string
  / Validation.from_unknown_record
  / Validation.from_known_record
  / Validation.from_compact
;;

let compare a b =
  let a = components a
  and b = components b in
  List.compare String.compare a b
;;

let equal a b =
  let a = components a
  and b = components b in
  List.equal String.equal a b
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
