(** An Individual is the smallest possible representation of a
    person's denotation. *)

(** {1 Structure} *)

type t

(** {2 Projection}

    An individual is projected as the following record:

    {eof@json[
      {
        "display_name": string,
        "bio": Option<string>,
        "slug": string,
        "first_name": Option<string>,
        "last_name": Option<string>,
        "gender": Option<Gender>,
        "avatar": Option<Scoped_url>,
        "email": Option<Email>,
        "url": Option<Url>,
        "other_emails": Set<Email>,
        "all_emails": Set<Email>,
        "other_urls": Set<Url>,
        "all_urls": Set<Url>,
        "has_names": bool,
        "has_url": bool,
        "has_last_name": bool,
        "has_first_name": bool,
        "has_gender": bool,
        "has_avatar": bool,
        "with_names": Option {
            "initials": string,
            "display": string
        }
      }
    ]eof} *)

(** {1 Individual API} *)

(** [to_syndication individual] convert [individual] into a [person]
    in Syndication sense.*)
val to_syndication : t -> Yocaml_syndication.Person.t

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

(** {1 Utilities} *)

(** [to_meta authors] create a list of creators
    [<meta name="creator" content="display-name"]/>. *)
val to_meta : Set.t -> Meta.t list
