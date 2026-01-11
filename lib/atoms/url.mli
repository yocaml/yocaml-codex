(** Describes (external) URLs, whose normalization yields {b a lot of
    information}. The representation is backed by the
    {{:https://ocaml.org/p/uri/latest} Uri library}. *)

type t

(** [http ?path url] build an http URL. *)
val http : ?path:Yocaml.Path.t -> string -> t

(** [https ?path url] build an https URL. *)
val https : ?path:Yocaml.Path.t -> string -> t

(** [from_string s] convert a [string] into *)
val from_string : string -> t

(** [to_string url] convert an [url] to a string. *)
val to_string : t -> string

(** [resolve ?on_query path url] resolves the [path] of the given url,
    you can manage the query params using the [on_query] flag. *)
val resolve
  :  ?on_query:
       [ `Remove
       | `Keep of (string * string list) list
       | `Set of (string * string list) list
       | `Update of (string * string list) list -> (string * string list) list
       ]
  -> Yocaml.Path.t
  -> t
  -> t

(** [compare a b] compare two urls. *)
val compare : t -> t -> int

(** [equal a b] equality between two urls. *)
val equal : t -> t -> bool

(** {1 Yocaml Related} *)

include Yocaml.Data.S with type t := t
include Yocaml.Data.Validation.S with type t := t
