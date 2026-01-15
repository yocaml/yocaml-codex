(** Describes (external) URLs, whose normalization yields {b a lot of
    information}. The representation is backed by the
    {{:https://ocaml.org/p/uri/latest} Uri library}. *)

(** {1 Structure} *)

type t

(** {2 Projection}

    An URL is projected as the following record:

    {eof@json[
      {
        "target": string,
        "scheme": string,
        "host": string,
        "port": Option<int>,
        "path": string,
        "has_port": bool,
        "query_params": Map<string, List<string>>,
        "query_string": Option<string>,
        "has_query_string": bool
      }
    ]eof}

    {3 Example with Jingoo}

    {eof@html[
      <a href="{{ url.target }}" class="link scheme-{{ url.scheme }}">
        Here is my URL
      </a>
    ]eof} *)

(** {2 Validation}

    URLs can be validated as [non-empty string] or records with a
    [target] field (which is a [non-empty string]). *)

(** {1 Manipulating URLs} *)

(** [http ?path url] build an http URL. *)
val http : ?path:Yocaml.Path.t -> string -> t

(** [https ?path url] build an https URL. *)
val https : ?path:Yocaml.Path.t -> string -> t

(** [to_string url] convert an [url] to a string. *)
val to_string : t -> string

(** [resolve ?on_query path url] resolves the [path] of the given url,
    you can manage the query params using the [on_query] flag. *)
val resolve
  :  ?on_query:
       [ `Remove
       | `Keep of (string * string list) list
       | `Set of (string * string list) list
       | `Update of (string * string list) list -> (string * string list) list
       ]
  -> Yocaml.Path.t
  -> t
  -> t

(** [name url] gives a standard name for a given URL. *)
val name : ?with_scheme:bool -> ?with_path:bool -> t -> string

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
