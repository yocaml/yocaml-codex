(** An Individual is the smallest possible representation of a
    person's denotation. *)

(** {1 Structure} *)

(* TODO: This module is work in progress. Need to be documented (and
   completed). *)

type t

(** {1 Individual API} *)

(** [to_syndication individual] convert [individual] into a [person]
    in Syndication sense.*)
val to_syndication : t -> Yocaml_syndication.Person.t

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
