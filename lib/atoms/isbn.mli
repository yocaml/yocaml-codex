(** Describes an {{:https://en.wikipedia.org/wiki/ISBN} ISBN}. *)

(** {1 Structure} *)

type t

(** {1 Manipulating ISBNs} *)

(** [to_string isbn] render a formatted ISBN. *)
val to_string : t -> string

(** [compare a b] compare two urls. *)
val compare : t -> t -> int

(** [equal a b] equality between two urls. *)
val equal : t -> t -> bool

(** {1 Yocaml Related} *)

include Yocaml.Data.S with type t := t
include Yocaml.Data.Validation.S with type t := t

(** {1 Enumerable} *)

include Sigs.SET_AND_MAP with type t := t
