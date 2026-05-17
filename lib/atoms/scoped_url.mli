(** Describes a scoped URL (can be local (a Path) or external (an URL)). *)

type t

(** {1 Manipulating URLs} *)

(** [internal p] build an internal URL. *)
val internal : Yocaml.Path.t -> t

(** [url p] build an external URL. *)
val url : Url.t -> t

(** [http ?path url] build an http URL. *)
val http : ?path:Yocaml.Path.t -> string -> t

(** [https ?path url] build an https URL. *)
val https : ?path:Yocaml.Path.t -> string -> t

(** [to_string url] convert an [url] to a string. *)
val to_string : t -> string

(** [compare a b] compare two urls. *)
val compare : t -> t -> int

(** [equal a b] equality between two urls. *)
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
