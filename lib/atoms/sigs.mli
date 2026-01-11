(** Reusable signatures, as arguments for functors to share
    interfaces. *)

module type COMPARABLE = sig
  (** A module that describes the [comparable] behaviour for
      expressions of type [t]. *)

  (** The type of a comparable value. *)
  type t

  (** [compare x y] returns [0] if [x] is equal to [y], a negative
      integer if [x] is less than [y], and a positive integer if [x]
      is greater than [y]. *)
  val compare : t -> t -> int
end

module type MODEL = sig
  (** Describe something that can be compared, projectable and validable. *)
  include COMPARABLE

  include Yocaml.Data.S with type t := t
  include Yocaml.Data.Validation.S with type t := t
end

module type PROJECTABLE_SET = sig
  (** A module that describe a projectable set. *)

  include Yocaml.Data.S
end

module type PROJECTABLE_MAP = sig
  (** A module that describe a projectable map. *)

  type 'a t

  val to_data : 'a Yocaml.Data.converter -> 'a t Yocaml.Data.converter
end

module type VALIDABLE_SET = sig
  (** A module that describe a Validable set. *)

  include Yocaml.Data.Validation.S
end

module type VALIDABLE_MAP = sig
  (** A module that describe a Validable map. *)

  type 'a t

  val from_data : 'a Yocaml.Data.validable -> 'a t Yocaml.Data.validable
end

module type SET = sig
  (** A module that describe a projectable and validable set. *)

  include Yocaml.Data.S
  include Yocaml.Data.Validation.S with type t := t
end

module type MAP = sig
  (** A module that describe a projectable and validable map. *)

  type 'a t

  val to_data : 'a Yocaml.Data.converter -> 'a t Yocaml.Data.converter
  val from_data : 'a Yocaml.Data.validable -> 'a t Yocaml.Data.validable
end
