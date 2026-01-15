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

(** {1 Yocaml Related} *)

include Yocaml.Data.S with type t := t
(* include Yocaml.Data.Validation.S with type t := t *)
