(** Reusable signatures, as arguments for functors to share
    interfaces. *)

(** {1 Projection}

    Signatures for making projection. *)

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
