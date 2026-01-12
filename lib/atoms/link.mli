(** Describes a link (URL) associated with a name and an optional
    description. The name can be calculated based on the URL. *)

(** {1 Structure} *)

type t

(** {2 Projection}

    A Link is projected as the following record:

    {eof@json[
      {
        "name": string,
        "url": Url.t,
        "target": string,
        "description": Option<int>,
        "has_description": bool
      }
    ]eof}

    The field [target] is a shortcut for [url.target].

    {3 Example with Jingoo}

    {eof@html[
      <a href="{{ link.target }}"
         class="link scheme-{{ link.url.scheme }}"
         {% if link.has_description %}
         title="{{ link.description }}"
         {% endif %}
       >
        {{ link.name }}
      </a>
    ]eof}

    {2 Validation}

    Links can be just an URL (an the [name] will be computed). Or the
    following record:

    {eof@json[
      {
        "name": Option<string>,
        "url": Url.t,
        "description": Option<string>
      }
    ]eof} *)

(** {1 Manipulating Links} *)

(** [compare a b] compare two urls. *)
val compare : t -> t -> int

(** [equal a b] equality between two urls. *)
val equal : t -> t -> bool

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
