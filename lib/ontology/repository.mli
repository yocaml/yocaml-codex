(** Describes a source repository (for CVS) associated with a
    forge. It can be used to resolve files (blobs) and provide
    information about known repositories. *)

(** {1 Structure} *)

type t

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

(** {1 Yocaml Related} *)

include Yocaml.Data.S with type t := t
(* include Yocaml.Data.Validation.S with type t := t *)
