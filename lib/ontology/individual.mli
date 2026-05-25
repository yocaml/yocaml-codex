(** An Individual is the smallest possible representation of a
    person's denotation (with a lot of optional fields). *)

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
        "social_accounts": Set<Social_account>,
        "has_bio": bool,
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
    ]eof}

    As you can see, an Individual holds a lot of information; however, as we
    will see, most of these fields are optional.

    {3 Example with Jingoo}

    {eof@html[
      <h1>Profile page of
         <a href="profile/{{ people.slug }}.html">
           {{ people.display_name }}
         </a>
      </h1>
      {% if people.has_bio %}
      <blockquote>
        {{ people.bio }}
      </blockquote>
      {% endif %}
    ]eof} *)

(** {2 Validation} *)

(** {@ocaml[
      open Codex_atoms
      open Codex_ontology

      let display_individual i = assert false
    ]} *)

(** {1 Individual API} *)

(** Returns the display name of an individual. *)
val display_name : t -> string

(** Returns the first name of an individual. *)
val first_name : t -> string option

(** Returns the last name of an individual. *)
val last_name : t -> string option

(** Returns the gender of an individual. *)
val gender : t -> Gender.t option

(** Returns the bio/synopsis of an individual. *)
val bio : t -> string option

(** Returns the avatar of an individual. *)
val avatar : t -> Scoped_url.t option

(** Returns the set of associated social accounts. *)
val social_accounts : t -> Social_account.Set.t

(** Returns the email of an individual. (uses [all_emails] field). *)
val email : t -> Email.t option

(** Returns the url of an individual. (uses [all_urls] field). *)
val url : t -> Url.t option

(** Returns the set of all associated emails. *)
val all_emails : t -> Email.Set.t

(** Returns the set of all associated urls. *)
val all_urls : t -> Url.Set.t

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
