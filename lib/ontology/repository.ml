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
      ; repository : string
      }
  | Unknown of
      { repository : string
      ; home : Url.t
      ; bug_tracker : Url.t option
      ; blob : Url.t
      }

let github ?(bug_tracker = `Derived) ~username ~repository () =
  Known { provider = Github username; repository; bug_tracker }
;;

let gitlab ?(bug_tracker = `Derived) ~username ~repository () =
  Known { provider = Gitlab username; repository; bug_tracker }
;;

let tangled ?(bug_tracker = `Derived) ~username ~repository () =
  Known { provider = Tangled username; repository; bug_tracker }
;;

let sourcehut ?(bug_tracker = `Derived) ~username ~repository () =
  Known { provider = Sourcehut username; repository; bug_tracker }
;;

let codeberg ?(bug_tracker = `Derived) ~username ~repository () =
  Known { provider = Codeberg username; repository; bug_tracker }
;;

let gitlab_org ?(bug_tracker = `Derived) ~name ~project ~repository () =
  Known { provider = Gitlab_org { name; project }; repository; bug_tracker }
;;

let make ?bug_tracker ~repository ~home ~blob () =
  Unknown { repository; home; bug_tracker; blob }
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
    Url.resolve (Yocaml.Path.abs [ username ]) base
  | Sourcehut username ->
    Url.resolve (Yocaml.Path.abs [ "~" ^ username ]) (Url.https "git.sr.ht")
  | Gitlab_org { name; project } ->
    Url.resolve (Yocaml.Path.abs [ name; project ]) base
;;

let home provider repository =
  account provider |> Url.resolve (Yocaml.Path.rel [ repository ])
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
             Url.https "todo.sr.ht", Yocaml.Path.abs [ "~" ^ user; repository ]
           | Gitlab _ | Gitlab_org _ ->
             home provider repository, Yocaml.Path.rel [ "-"; "issues" ]
           | Github _ | Tangled _ | Codeberg _ ->
             home provider repository, Yocaml.Path.rel [ "issues" ]
         in
         Some (Url.resolve fragment home))
      bug_tracker
;;

(* let releases = function *)
(*   | Known { provider; repository; _ } -> *)
(*     let fragment = *)
(*       match provider with *)
(*       | Gitlab _ | Gitlab_org _ -> Yocaml.Path.rel [ "-"; "releases" ] *)
(*       | Tangled _ -> Yocaml.Path.rel [ "tags" ] *)
(*       | Sourcehut _ -> Yocaml.Path.rel [ "refs" ] *)
(*       | _ -> Yocaml.Path.rel [ "releases" ] *)
(*     in *)
(*     Url.resolve fragment (home provider repository) *)
(*   | _ -> assert false *)
(* ;; *)

let to_data repo =
  let open Yocaml.Data in
  let home = homepage repo in
  let bug_tracker = bug_tracker repo in
  record
    [ "name", string @@ name repo
    ; "home", Url.to_data home
    ; "bug_tracker", option Url.to_data bug_tracker
    ; "has_bug_tracker", bool @@ Option.is_some bug_tracker
    ]
;;
