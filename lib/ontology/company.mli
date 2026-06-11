(** Describe a company. (A "place" where people works). The model does not
    handle notion of location because it is common for a company to
    have more than one location and YOCaml is not a corporate tool. *)

(** {1 Structure} *)

type t

(** {2 Projection}

    An individual is projected as the following record:

    {eof@json[
      {
        "name": string,
        "description": Option<string>,
        "small_logo": Option<Scoped_url>,
        "large_logo": Option<Scoped_url>,
        "logo": Option<Scoped_url>,
        "cover": Option<Media>,
        "email": Option<Email>,
        "url": Option<Url>,
        "other_emails": Set<Email>,
        "all_emails": Set<Email>,
        "other_urls": Set<Url>,
        "all_urls": Set<Url>,
        "social_accounts": Set<Social_account>,
        "has_email", bool,
        "has_url": bool,
        "has_description": bool,
        "has_small_logo": bool,
        "has_large_logo": bool,
        "has_logo": bool
      }
    ]eof}

    - [logo] is computed based on [large_logo] or [small_logo].

    {3 Example with Jingoo}

    {eof@html[
      <h1>Page of company {{ company.name }}</h1>
      {% if company.has_description %}
        <p>{{ company.description }}</p>
      {% endif %}
    ]eof}

    {2 ValidationValidation}

    - Can be validated just using a name
    - Can be validated using a mailbox
    - Can be validated using a full record. *)

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
