(** Describe a company. (A "place" where people works). The model does not
    handle notion of location because it is common for a company to
    have more than one location and YOCaml is not a corporate tool. *)

(** {1 Structure} *)

type t

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
