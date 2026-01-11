(** Set of functors for constructing Maps that can be projected and
    validated. *)

(** {1 Structure}

    {2 Projection}

    A map is projected as the following records:

    {eof@json[
      {
        kind: "map",
        length: int,
        is_empty: bool,
        is_not_empty: bool,
        elements: list(key, value)
      }
    ]eof}

    Where [elements] is a list of pair [key], [value].

    {2 Validation}

    To be validated, a map must comply with the following format:
    - [list] A list can be validated as a map.
    - Or [{ elements = list; ..}] a record containing at least one field
      [elements] (or [set], [values], [all]) which is a list.

    A [list], or the [elements] field need to follow the validation

    - [pair key value] A pair of key and values
    - Or [{key; value; ...}]  a record of key and value where [key]
      can also [k], [index], [i], [fst], [first] and where [value] can
      also be [val], [v], [snd], [second]. *)

(** {1 Projection}

    Construction of Map that can be standardised: [to_data]. *)

module Projectable (C : Sigs.COMPARABLE) (_ : Yocaml.Data.S with type t = C.t) :
  Sigs.PROJECTABLE_MAP with type key = C.t

(** {1 Validation}

    Construction of Map that can be validated: [from_data]. *)

module Validable
    (C : Sigs.COMPARABLE)
    (_ : Yocaml.Data.Validation.S with type t = C.t) :
  Sigs.VALIDABLE_MAP with type key = C.t

(** {1 Validation and Projection}

    Construction of Map that can be validated: [from_data], and
    standarized: [to_data]. *)

module Make
    (C : Sigs.COMPARABLE)
    (_ : Yocaml.Data.S with type t = C.t)
    (_ : Yocaml.Data.Validation.S with type t = C.t) :
  Sigs.MAP with type key = C.t

(** {1 Predefined Maps} *)

module String : Sigs.MAP with type key = string
