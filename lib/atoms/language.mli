(** Describes a language, optionally scoped to a region. *)

(** {1 Structure} *)

type t

(** [to_string lang] renders the language as a string
    (for example ["en"] or ["en-KE"]). *)
val to_string : t -> string

(** [compare a b] compare two languages. *)
val compare : t -> t -> int

(** [equal a b] equality between two languages. *)
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
