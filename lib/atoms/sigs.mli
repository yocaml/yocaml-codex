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

  type elt

  include Yocaml.Data.S
  include Yocaml.Data.Validation.S with type t := t

  module Zero_or_more : sig
    (** [Zero_or_more] allows a list to be treated as a primary element and a
        set of additional elements. This makes it possible to have a
        primary value and additional values. *)

    type set := t

    (** The pair is normalized using the following record:

        {eof@json[
          {
            "main": Option<T>,
            "has_main": Bool,
            "other": Set<T>,
            "all": Set<T>
          }
        ]eof}

        The field [all] is [main + other]. If there is no [main],
        there is no [other]. *)

    include Yocaml.Data.S
    include Yocaml.Data.Validation.S with type t := t

    val empty : t
    val one : elt -> t
    val more : elt list -> t
    val main : t -> elt option
    val other : t -> set
    val all : t -> set
  end
end

module type MAP = sig
  (** A module that describe a projectable and validable map. *)

  type 'a t

  val to_data : 'a Yocaml.Data.converter -> 'a t Yocaml.Data.converter
  val from_data : 'a Yocaml.Data.validable -> 'a t Yocaml.Data.validable
end

module type SET_AND_MAP = sig
  (** Handle SET and MAP (In order to be include) *)

  type t

  module Set : sig
    include Stdlib.Set.S with type elt = t
    include SET with type t := t and type elt := elt
  end

  module Map : sig
    include Stdlib.Map.S with type key = t
    include MAP with type 'a t := 'a t
  end

  module Zero_or_more = Set.Zero_or_more
end
