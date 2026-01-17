(** Represents an account on a social media platform.

    The model infers a lot of data if the repository forge is:
    - {{:https://github.com/} Github}
    - {{:https://gitlab.com} Gitlab}
    - {{:https://codeberg.org} Codeberg}
    - {{:https://sr.ht} Sourcehut}
    - {{:https://x.com} X/Twitter}
    - {{:https://bsky.app} Bluesky}
    - {{:https://joinmastodon.org} Mastodon}
    - {{:https://cara.app} Cara}
    - {{:https://linkedin} Linkedin}
    - {{:https://instagram.com} Instagram}
    - {{:https://facebook} Facebook}
    - {{:https://www.threads.com/} Threads} *)

(** {1 Structure} *)

type t

(** {2 Projection}

    A Social Account is projected as the following record:

    {eof@json[
      {
        "kind": string,
        "is_known": bool,
        "is_custom": bool,
        "username": string,
        "domain": Url,
        "url", Url
      }
    ]eof}

    - [kind] is the provider (ie: [github], [mastodon], [x])
    - [is_known] is [true] if the provider is one of the list
    - [is_custom] is [not is_known]
    - [username] the username of the social media account
    - [domain] the main url of the social media platform (ie: [https://x.com])
    - [url] the URL to access to the account.

    {3 Example with Jingoo}

    {eof@html[
      <a href="{{ account.url.target }}"
         title="my account on {{ account.kind }}">
         {% if account.is_known %}
         <img src="/images/{{ account.kind }}.svg">
         {% endif %}
         {{ account.username }}
      </a>
    ]eof}

    {2 Validation}

    {@ocaml[
      open Codex_atoms
      open Codex_ontology

      let display_account account =
        Format.asprintf
          "%s - %s"
          (account |> Social_account.username)
          (account |> Social_account.url |> Url.to_string)
      ;;
    ]}

    To ensure a compact social account expression, there are several ways
    to validate an account.

    {3 Compact approach}

    [string "kind/user"] (or [mastodon/instance/username]). Some examples:

    {eof@ocaml[
      # Social_account.from_data
          Yocaml.Data.(string "bsky/xvw.lol")
        |> Result.map display_account
      - : (string, Yocaml.Data.Validation.value_error) result =
      Ok "xvw.lol - https://bsky.app/profile/xvw.lol"
    ]eof}

    You can use the following kinds:

    - [github.com], [github], [gh] for Github
    - [gitlab.com], [gitlab], [gl] for Gitlab
    - [tangled.org], [tangled], [tl] for Tangled
    - [codeberg.org], [codeberg], [cb] for Codeberg
    - [sourcehut.org], [sr.ht], [git.sr.ht] [sourceht], [sr] for Sourcehut
    - [x.com], [twitter.com], [x], [twitter] for Twitter
    - [bsky.app], [bluesky], [bsky] for Bluesky
    - [linkedin.com], [linkedin] for Linkedin
    - [instagram.com], [instagram], [insta], [ig] for Instagram
    - [facebook.com], [facebook], [fb] for Facebook
    - [cara.app], [cara] for Cara
    - [trheads.com], [threads] for Threads

    For example:

    {eof@ocaml[
      # Social_account.from_data
          Yocaml.Data.(string "ig/vdwxv")
        |> Result.map display_account
      - : (string, Yocaml.Data.Validation.value_error) result =
      Ok "vdwxv - https://instagram.com/vdwxv"
    ]eof}

    {4 Compact approach for mastodon}

    You can also use the form [@instance@username] for a social
    account related to a Mastodon Instance ([https://] is not
    mandatory so [@merveilles.town@xvw] is equivalent to
    [@https://merveilles.town@xvw]):

    {eof@ocaml[
      # Social_account.from_data
          Yocaml.Data.(string "@merveilles.town@xvw")
        |> Result.map display_account
      - : (string, Yocaml.Data.Validation.value_error) result =
      Ok "merveilles.town/xvw - https://merveilles.town/@xvw"
    ]eof}

    {3 Expanded version}

    Here is an example of the expanded version for Mastodon:

    {eof@ocaml[
      # Social_account.from_data Yocaml.Data.(record [
          "instance", string "https://merveilles.town"
        ; "username", string "xvw"
        ]) |> Result.map display_account
      - : (string, Yocaml.Data.Validation.value_error) result =
      Ok "merveilles.town/xvw - https://merveilles.town/@xvw"
    ]eof}

    And here is an example for a Bluesky account:

    {eof@ocaml[
      # Social_account.from_data Yocaml.Data.(record [
          "platform", string "bsky"
        ; "username", string "xvw.lol"
        ]) |> Result.map display_account
      - : (string, Yocaml.Data.Validation.value_error) result =
      Ok "xvw.lol - https://bsky.app/profile/xvw.lol"
    ]eof}

    [platform] can be substitute by [kind] or [network].

    {3 Your own social media account provider}

    If your social media platform is not supported, you can open a
    ticket (obviously) or use the manual representation of an account:

    {eof@json[
      {
        "kind": Option<string>,
        "url": Url,
        "username": string
      }
    ]eof}

    For example:

    {eof@ocaml[
      # Social_account.from_data Yocaml.Data.(record [
          "platform", string "muhokama"
        ; "username", string "xvw"
        ; "url", string "https://ring.muhokama.fun/u/xvw"
        ]) |> Result.map display_account
      - : (string, Yocaml.Data.Validation.value_error) result =
      Ok "xvw - https://ring.muhokama.fun/u/xvw"
    ]eof} *)

(** {1 Building Social media accounts} *)

(** Build a social media account (not supported by default). *)
val make : ?kind:string -> url:Url.t -> username:string -> unit -> t

(** Build a Mastodon social media account. *)
val mastodon : instance:Url.t -> username:string -> unit -> t

(** Build a Github social media account. *)
val github : username:string -> unit -> t

(** Build a Gitlab social media account. *)
val gitlab : username:string -> unit -> t

(** Build a Codeberg social media account. *)
val codeberg : username:string -> unit -> t

(** Build a Sourcehut social media account. *)
val sourcehut : username:string -> unit -> t

(** Build a X social media account. *)
val x : username:string -> unit -> t

(** Build a X social media account. {b see:} {!val:x}. *)
val twitter : username:string -> unit -> t

(** Build a Bluesky social media account. *)
val bluesky : username:string -> unit -> t

(** Build a Bsky social media account. {b see:} {!val:bluesky}. *)
val bsky : username:string -> unit -> t

(** Build a Linkedin social media account. *)
val linkedin : username:string -> unit -> t

(** Build a Instagram social media account. *)
val instagram : username:string -> unit -> t

(** Build a Facebook social media account. *)
val facebook : username:string -> unit -> t

(** Build a Threads social media account. *)
val threads : username:string -> unit -> t

(** Build a Cara social media account. *)
val cara : username:string -> unit -> t

(** {1 Manipulating Social media accounts} *)

(** Get the main domain of the social media account. *)
val domain : t -> Url.t

(** Get the URL of the social media account. *)
val url : t -> Url.t

(** Get the username of the social media account. *)
val username : t -> string

(** [compare a b] compare two accounts (using [url]). *)
val compare : t -> t -> int

(** [equal a b] equality between two accounts (using [url]). *)
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
