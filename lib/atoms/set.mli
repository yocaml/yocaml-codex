(** Set of functors for constructing Sets that can be projected and
    validated. *)

(** {1 Structure}

    {2 Projection}

    A set is projected as the following records:

    {eof@json[
      {
        kind: "set",
        length: int,
        is_empty: bool,
        is_not_empty: bool,
        elements: list
      }
    ]eof}

    Where [elements] is the set of all elements.

    {2 Validation}

    To be validated, a set must comply with the following format:
    - [list] A list can be validated as a set.
    - Or [{ elements = list; ..}] a record containing at least one field
      [elements] (or [set], [values], [all]) which is a list. *)

(** {1 Projection}

    Construction of Set that can be standardised: [to_data]. *)

module Projectable (C : Sigs.COMPARABLE) (_ : Yocaml.Data.S with type t = C.t) :
  Sigs.PROJECTABLE_SET with type elt = C.t

(** {1 Validation}

    Construction of Set that can be validated: [from_data]. *)

module Validable
    (C : Sigs.COMPARABLE)
    (_ : Yocaml.Data.Validation.S with type t = C.t) :
  Sigs.VALIDABLE_SET with type elt = C.t

(** {1 Validation and Projection}

    Construction of Set that can be validated: [from_data], and
    standarized: [to_data]. *)

module Make
    (C : Sigs.COMPARABLE)
    (_ : Yocaml.Data.S with type t = C.t)
    (_ : Yocaml.Data.Validation.S with type t = C.t) :
  Sigs.SET with type elt = C.t

(** {1 Predefined Sets} *)

module String : Sigs.SET with type elt = string
