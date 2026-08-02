(** Describes Email Adress, based of
    {{:https://ocaml.org/p/emile/latest} Emile library}. *)

(** {1 Structure} *)

type t

(** {2 Projection}

    An email is projected as the following record:

    {eof@json[
      {
        "address": string,
        "local": string,
        "domain": string,
        "md5": string
      }
    ]eof}

    Where for example [xavier@xvw.lol]:
    - [address] is ["xavier@xvw.lol"]
    - [local] is ["xavier"]
    - [domain] is ["xvw.lol"]
    - [md5] is the hashed version of [address] (in md5)

    {2 Example with Jingoo}

    {eof@html[
      <a href="mailto:{{ email.address }}">
        {{ email.local}}_AT_{{ email.domain }}
      </a>
    ]eof}

    {2 Validation}

    {@ocaml[
    open Codex_atoms
    ]}

    Validating an address isn't a big deal; it's just a simple string.

    {@ocaml[
      # Email.from_data
          Yocaml.Data.(string "xavier@email.com")
        |> Result.map Email.to_string ;;
      - : (string, Yocaml.Data.Validation.value_error) result =
      Ok "xavier@email.com"
    ]} *)

(** {1 Manipulating emails} *)

(** [to_string addr] render te [addr] as a [string]. *)
val to_string : t -> string

(** [compare a b] compare two emails. *)
val compare : t -> t -> int

(** [equal a b] equality between two emails. *)
val equal : t -> t -> bool

(** Validation extracting a name and an email. For example:

    {@ocaml[
      # Email.from_mailbox
          "Xavier Van de Woestyne <xavier@me.com>" ;;
      - : (string * Email.t) Yocaml.Data.Validation.validated_value =
      Ok ("Xavier Van de Woestyne", <abstr>)
    ]} *)
val from_mailbox : (string, string * t) Yocaml.Data.validator

(** {1 Yocaml Related} *)

include Yocaml.Data.S with type t := t
include Yocaml.Data.Validation.S with type t := t

(** {1 Enumerable} *)

include Sigs.SET_AND_MAP with type t := t
