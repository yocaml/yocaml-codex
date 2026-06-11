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
        "birthday": Option<Datetime>,
        "email": Option<Email>,
        "url": Option<Url>,
        "other_emails": Set<Email>,
        "all_emails": Set<Email>,
        "other_urls": Set<Url>,
        "all_urls": Set<Url>,
        "other_companies": Set<Company>,
        "all_companies": Set<Company>,
        "social_accounts": Set<Social_account>,
        "has_bio": bool,
        "has_names": bool,
        "has_email", bool,
        "has_url": bool,
        "has_company": bool,
        "has_last_name": bool,
        "has_first_name": bool,
        "has_gender": bool,
        "has_avatar": bool,
        "has_birthday", bool
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

      let display_individual i =
        Format.asprintf
          "%s (%a, %a) - %a"
          (i |> Individual.display_name)
          (Format.pp_print_option Format.pp_print_string)
          (i |> Individual.first_name)
          (Format.pp_print_option Format.pp_print_string)
          (i |> Individual.last_name)
          (Format.pp_print_option Format.pp_print_string)
          (i |> Individual.email |> Option.map Email.to_string)
      ;;
    ]}

    Like for other models there are several ways to validate an
    individual. *)

(** {3 Compact approach}

    Just using a display name:

    {@ocaml[
      # Yocaml.Data.(string "Xavier Van de Woestyne")
        |> Individual.from_data
        |> Result.map display_individual ;;
      - : (string, Yocaml.Data.Validation.value_error) result =
      Ok "Xavier Van de Woestyne (Xavier, Van de Woestyne) - "
    ]}

    Using the form: [fname/alias/lmame]:

    {@ocaml[
      # Yocaml.Data.(string "Xavier/ xvw /Van de Woestyne")
        |> Individual.from_data
        |> Result.map display_individual ;;
      - : (string, Yocaml.Data.Validation.value_error) result =
      Ok "xvw (Xavier, Van de Woestyne) - "
    ]}

    Using a Mailbox:

    {@ocaml[
      # Yocaml.Data.(string "Xavier Van de Woestyne <xavier@email.com>")
        |> Individual.from_data
        |> Result.map display_individual ;;
      - : (string, Yocaml.Data.Validation.value_error) result =
      Ok "Xavier Van de Woestyne (Xavier, Van de Woestyne) - xavier@email.com"
    ]}

    Or coupling mailbox with the previous form:

    {@ocaml[
      # Yocaml.Data.(string "Xavier / xvw / Van de Woestyne <xavier@email.com>")
        |> Individual.from_data
        |> Result.map display_individual ;;
      - : (string, Yocaml.Data.Validation.value_error) result =
      Ok "xvw (Xavier, Van de Woestyne) - xavier@email.com"
    ]}

    You can see that the validation function attempts to infer the
    first name and last name from the display name. If you want
    to be more precise for each member of your entity, you might
    as well use a less concise validation method. *)

(** {3 Expanded version} *)

(** The expanded validation uses a record:

    {@ocaml[
      # Yocaml.Data.(
           record [
             "display_name", string "xvw";
             "first_name", string "Xavier";
             "last_name", string "Van de Woestyne";
             "emails", list_of string ["xavier@email.com"; "xavier@lol.com"]
           ]
         )
         |> Individual.from_data
         |> Result.map display_individual ;;
      - : (string, Yocaml.Data.Validation.value_error) result =
      Ok "xvw (Xavier, Van de Woestyne) - xavier@email.com"
    ]} *)

(** {1 Individual API} *)

(** Build an individual. *)
val make
  :  ?gender:Gender.t
  -> ?first_name:string
  -> ?last_name:string
  -> ?email:Email.t
  -> ?emails:Email.Set.t
  -> ?url:Url.t
  -> ?urls:Url.Set.t
  -> ?bio:string
  -> ?avatar:Scoped_url.t
  -> ?birthday:Yocaml.Datetime.t
  -> ?social_accounts:Social_account.Set.t
  -> ?company:Company.t
  -> ?companies:Company.Set.t
  -> string
  -> t

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

(** Returns the birthday of an individual. *)
val birthday : t -> Yocaml.Datetime.t option

(** Returns the set of associated social accounts. *)
val social_accounts : t -> Social_account.Set.t

(** Returns the email of an individual. (uses [all_emails] field). *)
val email : t -> Email.t option

(** Returns the url of an individual. (uses [all_urls] field). *)
val url : t -> Url.t option

(** Returns the company of an individual. (uses [all_companies] field). *)
val company : t -> Company.t option

(** Returns the set of all associated emails. *)
val all_emails : t -> Email.Set.t

(** Returns the set of all associated urls. *)
val all_urls : t -> Url.Set.t

(** Returns the set of all associated companies. *)
val all_companies : t -> Company.Set.t

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

(** [to_meta author] create the related
    [<meta name="author" content="display-name"]/>. *)
val to_meta : t -> Meta.t

(** Returns the open graph representation of an individual (as a profile). *)
val to_open_graph : t -> Codex_open_graph.Kind.t
