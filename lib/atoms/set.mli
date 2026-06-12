(** Set of functors for constructing Sets that can be projected and
    validated. *)

(** {1 Structure}

    {2 Projection}

    A set is projected as the following record:

    {eof@json[
      {
        "kind": "set",
        "length": int,
        "is_empty": bool,
        "is_not_empty": bool,
        "elements": List<A>
      }
    ]eof}

    Where [elements] is the set of all elements.

    {2 Validation}

    To be validated, a set must comply with the following format:
    - [list] A list can be validated as a set.
    - Or [{ elements = list; ..}] a record containing at least one field
      [elements] (or [set], [values], [all]) which is a list. *)

(** {1 Helpers} *)

val collapse_with_option
  :  (module Stdlib.Set.S with type elt = 'a and type t = 'b)
  -> 'b
  -> 'a option
  -> 'a option * 'b * 'b

(** {1 Projection}

    Construction of Set that can be standardised: [to_data]. *)

module Projectable
    (Set : Stdlib.Set.S)
    (_ : Yocaml.Data.S with type t = Set.elt) :
  Sigs.PROJECTABLE_SET with type t = Set.t

(** {1 Validation}

    Construction of Set that can be validated: [from_data]. *)

module Validable
    (Set : Stdlib.Set.S)
    (_ : Yocaml.Data.Validation.S with type t = Set.elt) :
  Sigs.VALIDABLE_SET with type t = Set.t

(** {1 Validation and Projection}

    Construction of Set that can be validated: [from_data], and
    standarized: [to_data]. *)

module Make
    (Set : Stdlib.Set.S)
    (_ : Yocaml.Data.S with type t = Set.elt)
    (_ : Yocaml.Data.Validation.S with type t = Set.elt) : sig
  include Sigs.SET with type t = Set.t

  module Zero_or_more : sig
    (** [Zero_or_more] allows a list to be treated as a primary element and a
        set of additional elements. This makes it possible to have a
        primary value and additional values. *)

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

    val main : t -> Set.elt option
    val other : t -> Set.t
    val all : t -> Set.t
  end
end

(** {1 Predefined Sets} *)

module String : sig
  include module type of Stdlib.Set.Make (Stdlib.String)
  include Sigs.SET with type t := t
end

module Datetime : sig
  include module type of Stdlib.Set.Make (Orderable.Datetime)
  include Sigs.SET with type t := t
end

module Path : sig
  include module type of Yocaml.Path.Set
  include Sigs.SET with type t := t
end
