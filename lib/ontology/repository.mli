(** Describes a source repository (for CVS) associated with a
    forge. It can be used to resolve files (blobs) and provide
    information about known repositories.

    The model infers a lot of data if the repository forge is:
    - {{:https://github.com/} Github}
    - {{:https://gitlab.com} Gitlab}
    - {{:https://codeberg.org} Codeberg}
    - {{:https://sr.ht} Sourcehut}
    - {{:https://tangled.org} Tangled} *)

(** {1 Structure} *)

type t

(** {2 Projection}

    A Repository is projected as the following record:

    {eof@json[
      {
        "name": string,
        "kind": string,
        "components": List<string>,
        "identifier": string,
        "is_known": bool,
        "is_custom": bool,
        "page": {
            "home": Url,
            "bug_tracker": Option<Url>,
            "releases": Option<Url>,
            "blob_root": Url,
            "has_bug_tracker": bool,
            "has_release": bool,
         }
      }
    ]eof}

    - [name] is the repository name
    - [kind] is the forge provider (ie: [github])
    - [components] is a list of string, ie for
      {:https://github.com/xhtmlboi/yocaml}, it is the
      list [["github"; "xhtmlboi"; "yocaml"]]
    - [identifier] is a compacted version of [components],
      ["github/xhtmlboi/yocaml"]
    - [pages] is a record that give some links.

    {3 Example with Jingoo}

    {eof@html[
      <div class="repository repository-{{ repository.kind }}">
        <h1>{{ repository.name }}</h1>
        <code>{{ repository.identifier }}</code>
        <nav>
          <a href="{{ repository.pages.home.target }}">www</a>
          {% if repository.pages.has_bug_tracker %}
          <a href="{{ repository.pages.bug_tracker.target }}">issues</a>
          {% enfif %}
          {% if repository.pages.has_releases %}
          <a href="{{ repository.pages.releases.target }}">releases</a>
          {% enfif %}
        </nav>
      </div>
    ]eof}

    {2 Validation}

    {@ocaml[
      open Codex_atoms
      open Codex_ontology

      let display_repo repo =
        [ "url", Some (Repository.homepage repo)
        ; "bug_tracker", Repository.bug_tracker repo
        ; "releases", Repository.releases repo
        ]
        |> List.map (fun (k, v) -> k, Option.map Url.to_string v)
      ;;
    ]}

    To ensure a compact repository expression, there are several ways
    to validate a repository.

    {3 Compact approach}

    [string "kind/user/repository"] (or [gitlab/org-name/proj/repo]
    for Gitlab organization) is the most compact approach, here are
    some examples:

    {eof@ocaml[
      # Repository.from_data
           Yocaml.Data.(string "github/xhtmlboi/yocaml")
        |> Result.map display_repo
      - : ((string * string option) list, Yocaml.Data.Validation.value_error)
          result
      =
      Ok
       [("url", Some "https://github.com/xhtmlboi/yocaml");
        ("bug_tracker", Some "https://github.com/xhtmlboi/yocaml/issues");
        ("releases", Some "https://github.com/xhtmlboi/yocaml/releases")]
    ]eof}

    You can use the following kinds:

    - [github.com], [github], [gh] for Github
    - [gitlab.com], [gitlab], [gl] for Gitlab
    - [tangled.org], [tangled], [tl] for Tangled
    - [codeberg.org], [codeberg], [cb] for Codeberg
    - [sourcehut.org], [sr.ht], [git.sr.ht] [sourceht], [sr] for Sourcehut

    An other example:

    {eof@ocaml[
      # Repository.from_data
           Yocaml.Data.(string "sr.ht/tim-ats-d/ofortune")
        |> Result.map display_repo
      - : ((string * string option) list, Yocaml.Data.Validation.value_error)
          result
      =
      Ok
       [("url", Some "https://git.sr.ht/~tim-ats-d/ofortune");
        ("bug_tracker", Some "https://todo.sr.ht/~tim-ats-d/ofortune");
        ("releases", Some "https://git.sr.ht/~tim-ats-d/ofortune/refs")]
    ]eof}

    {3 Using URLs}

    Another way is to directly use an URL:

    {eof@ocaml[
      # Repository.from_data
           Yocaml.Data.(string "https://github.com/ocaml/ocaml")
        |> Result.map display_repo
      - : ((string * string option) list, Yocaml.Data.Validation.value_error)
          result
      =
      Ok
       [("url", Some "https://github.com/ocaml/ocaml");
        ("bug_tracker", Some "https://github.com/ocaml/ocaml/issues");
        ("releases", Some "https://github.com/ocaml/ocaml/releases")]
    ]eof}

    {3 Expanded version}

    {eof@ocaml[
      # Repository.from_data Yocaml.Data.(record [
           "user", string "xhtmlboi"
        ;  "repo", string "yocaml"
        ;  "kind", string "github"
        ]) |> Result.map display_repo
      - : ((string * string option) list, Yocaml.Data.Validation.value_error)
          result
      =
      Ok
       [("url", Some "https://github.com/xhtmlboi/yocaml");
        ("bug_tracker", Some "https://github.com/xhtmlboi/yocaml/issues");
        ("releases", Some "https://github.com/xhtmlboi/yocaml/releases")]
    ]eof}

    You can also override infered [bug_trackers] and [releases] fields:

    {eof@ocaml[
      # Repository.from_data Yocaml.Data.(record [
           "user", string "xhtmlboi"
        ;  "repo", string "yocaml"
        ;  "kind", string "github"
        ;  "bug_tracker", string "<none>"
        ]) |> Result.map display_repo
      - : ((string * string option) list, Yocaml.Data.Validation.value_error)
          result
      =
      Ok
       [("url", Some "https://github.com/xhtmlboi/yocaml"); ("bug_tracker", None);
        ("releases", Some "https://github.com/xhtmlboi/yocaml/releases")]
    ]eof}

    or giving your own link:

    {eof@ocaml[
      # Repository.from_data Yocaml.Data.(record [
           "user", string "xhtmlboi"
        ;  "repo", string "yocaml"
        ;  "kind", string "github"
        ;  "bug_tracker", string "https://jenkins.cargocut.org/yocaml"
        ]) |> Result.map display_repo
      - : ((string * string option) list, Yocaml.Data.Validation.value_error)
          result
      =
      Ok
       [("url", Some "https://github.com/xhtmlboi/yocaml");
        ("bug_tracker", Some "https://jenkins.cargocut.org/yocaml");
        ("releases", Some "https://github.com/xhtmlboi/yocaml/releases")]
    ]eof}

    You can also mix compact and expanded form:

    {eof@ocaml[
      # Repository.from_data Yocaml.Data.(record [
           "repo", string "gh/xhtmlboi/yocaml"
        ;  "bug_tracker", string "https://jenkins.cargocut.org/yocaml"
        ]) |> Result.map display_repo
      - : ((string * string option) list, Yocaml.Data.Validation.value_error)
          result
      =
      Ok
       [("url", Some "https://github.com/xhtmlboi/yocaml");
        ("bug_tracker", Some "https://jenkins.cargocut.org/yocaml");
        ("releases", Some "https://github.com/xhtmlboi/yocaml/releases")]
    ]eof}

    {3 You own forge}

    If your forge is not supported, you can open a ticket (obviously)
    or use the manual representation of the forges:

    {eof@json[
      {
        "kind": Option<string>,
        "default_branch": Option<string>,
        "bug_tracker": Option<Url>,
        "releases": Option<Url>,
        "repository": string,
        "home": Url,
        "blob": Url
      }
    ]eof}

    A [blob] field that can resolve a file using the format
    [blob-url/branch-name/${file to be resolved}] is mandatory to make
    the full API consistant.

    {eof@ocaml[
      # Repository.from_data Yocaml.Data.(record [
          "repository", string "my-repo"
        ; "home", string "https://my-forge.com/my-repo"
        ; "blob", string "https://my-forge.com/my-repo/blob"
        ]) |> Result.map display_repo
      - : ((string * string option) list, Yocaml.Data.Validation.value_error)
          result
      =
      Ok
       [("url", Some "https://my-forge.com/my-repo"); ("bug_tracker", None);
        ("releases", None)]
    ]eof} *)

(** {1 Building repositories} *)

(** Build a Github repository. *)
val github
  :  ?bug_tracker:Url.t Derivable.opt
  -> ?releases:Url.t Derivable.opt
  -> username:string
  -> repository:string
  -> unit
  -> t

(** Build a Gitlab repository. *)
val gitlab
  :  ?bug_tracker:Url.t Derivable.opt
  -> ?releases:Url.t Derivable.opt
  -> username:string
  -> repository:string
  -> unit
  -> t

(** Build a Tangled repository. *)
val tangled
  :  ?bug_tracker:Url.t Derivable.opt
  -> ?releases:Url.t Derivable.opt
  -> username:string
  -> repository:string
  -> unit
  -> t

(** Build a Sourcehut repository. *)
val sourcehut
  :  ?bug_tracker:Url.t Derivable.opt
  -> ?releases:Url.t Derivable.opt
  -> username:string
  -> repository:string
  -> unit
  -> t

(** Build a Codeberg repository. *)
val codeberg
  :  ?bug_tracker:Url.t Derivable.opt
  -> ?releases:Url.t Derivable.opt
  -> username:string
  -> repository:string
  -> unit
  -> t

(** Build a Gitlab (organization) repository. *)
val gitlab_org
  :  ?bug_tracker:Url.t Derivable.opt
  -> ?releases:Url.t Derivable.opt
  -> name:string
  -> project:string
  -> repository:string
  -> unit
  -> t

(** Build a repository (component by component). [blob] is the main
    URL for resolving files (should have the form: ["url/branch/.."]). *)
val make
  :  ?kind:string
  -> ?default_branch:string
  -> ?bug_tracker:Url.t
  -> ?releases:Url.t
  -> repository:string
  -> home:Url.t
  -> blob:Url.t
  -> unit
  -> t

(** {1 Manipulating repositories} *)

(** Get the homepage of a given repository. *)
val homepage : t -> Url.t

(** Get the bug-tracker of a given repository. *)
val bug_tracker : t -> Url.t option

(** Get the releases page of a given repository. *)
val releases : t -> Url.t option

(** [resolve ?is_file ?branch path repo] will resolve the URL of a
    given path. *)
val resolve : ?is_file:bool -> ?branch:string -> Yocaml.Path.t -> t -> Url.t

(** [compare a b] compare two repositories (using [identifier]). *)
val compare : t -> t -> int

(** [equal a b] equality between two repository (using [identifier]). *)
val equal : t -> t -> bool

(** {1 Yocaml Related} *)

include Yocaml.Data.S with type t := t
include Yocaml.Data.Validation.S with type t := t

(** {1 Enumerable} *)

module Set : sig
  include Stdlib.Set.S with type elt = t
  include Sigs.SET with type t := t
end

module Map : sig
  include Stdlib.Map.S with type key = t
  include Sigs.MAP with type 'a t := 'a t
end
