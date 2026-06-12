(** Describes a tag / keyword. *)

(** {1 Structure} *)

type t

(** {2 Projection}

    A tag is projected as the following record:

    {eof@json[
      {
        "value": string,
        "slug": string
      }
    ]eof}

    {3 Example with Jingoo}

    {eof@html[
      <span class="tag tag-{{ tag.slug }}">{{ tag.value }}</span>
    ]eof} *)

(** {2 Validation}

    Tags can be validated from strings. Validation trims whitespace,
    removes a leading hash character, and rejects empty or blank values. *)

(** {1 Manipulating tags} *)

(** [to_string tag] renders a tag as a string. *)
val to_string : t -> string

(** [compare a b] compares two tags. *)
val compare : t -> t -> int

(** [equal a b] equality between two tags. *)
val equal : t -> t -> bool

(** {1 Yocaml related} *)

include Yocaml.Data.S with type t := t
include Yocaml.Data.Validation.S with type t := t

(** {1 Enumerable} *)

include Sigs.SET_AND_MAP with type t := t

(** {1 Utilities} *)

(** [of_list xs] builds a set of tags from a list of strings. *)
val of_list : string list -> Set.t

(** [to_meta tags] projects a non-empty set of tags into a single
    [keywords] meta tag, or returns [None] if the set is empty. *)
val to_meta : Set.t -> Meta.t
