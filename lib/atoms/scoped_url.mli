(** Describes a scoped URL (can be local (a Path) or external (an URL)). *)

(** {1 Structure} *)

(** A scoped URL is either a path or a URL. It can therefore be validated
    as either a path or a URL. *)

type t

(** {2 Projection}

    A Scoped URL is projected as the following record:

    {eof@json[
      {
        "kind": "external" | "internal",
        "target": string,
        "url": Option<Url>
      }
    ]eof}

    If [kind] is ["external"], there is a field [url] with the URL
    representation.

    {3 Example with Jingoo}

    {eof@html[
      <img src="{{ scoped_url.target }}" alt="an avatar"/>
    ]}

    {2 Validation}

    A scoped url can be validated eithers as [path] or as [url]. *)

(** {1 Manipulating URLs} *)

(** [internal p] build an internal URL. *)
val internal : Yocaml.Path.t -> t

(** [url p] build an external URL. *)
val url : Url.t -> t

(** [http ?path url] build an http URL. *)
val http : ?path:Yocaml.Path.t -> string -> t

(** [https ?path url] build an https URL. *)
val https : ?path:Yocaml.Path.t -> string -> t

(** [to_string url] convert an [url] to a string. *)
val to_string : t -> string

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
