(** Describes the Open Graph kind of a resource.

    A kind represents the high-level type of a document, for example
    a website or an article. *)

(** {1 Structure} *)

type t

(** {1 Constructors} *)

(** Open Graph [website] kind.

    Corresponds to the Open Graph meta tag:

    {eof@html[
      <meta property="og:type" content="website" />
    ]eof} *)
val website : t

(** Open Graph [article] kind.

    Corresponds to the following Open Graph meta tags
    when all optional values are provided:

    {eof@html[
      <meta property="og:type" content="article" />
      <meta property="article:published_time" content="2024-01-01T12:00:00Z" />
      <meta property="article:modified_time" content="2024-01-10T09:30:00Z" />
      <meta property="article:section" content="Technology" />
      <meta property="article:tag" content="ocaml" />
      <meta property="article:tag" content="..." />
      <meta property="article:author" content="profile-url-author-1" />
      <meta property="article:author" content="..." />
    ]eof} *)
val article
  :  ?updated_time:Yocaml.Datetime.t
  -> ?authors:Codex_atoms.Url.Set.t
  -> ?tags:Codex_atoms.Tag.Set.t
  -> published_time:Yocaml.Datetime.t
  -> section:string
  -> unit
  -> t

(** Open Graph [book] kind.

    Corresponds to the following Open Graph meta tags
    when all optional values are provided:

    {eof@html[
      <meta property="og:type" content="book" />
      <meta property="book:isbn" content="978-1449323912" />
      <meta property="book:release_date" content="2024-01-01T12:00:00Z" />
      <meta property="book:tag" content="ocaml" />
      <meta property="book:tag" content="..." />
      <meta property="book:author" content="profile-url-author-1" />
      <meta property="book:author" content="..." />
    ]eof} *)
val book
  :  ?authors:Codex_atoms.Url.Set.t
  -> ?tags:Codex_atoms.Tag.Set.t
  -> Codex_atoms.Isbn.t
  -> Yocaml.Datetime.t
  -> t

(** Open Graph [profile] kind.

    Corresponds to the following Open Graph meta tags
    when all optional values are provided:

    {eof@html[
      <meta property="og:type" content="profile" />
      <meta property="profile:username" content="jdo" />
      <meta property="profile:first_name" content="John" />
      <meta property="profile:last_name" content="Doe" />
      <meta property="profile:gender" content="male" />
    ]eof} *)
val profile
  :  ?first_name:string
  -> ?last_name:string
  -> ?gender:Codex_atoms.Gender.t
  -> string
  -> t

(** [to_open_graph kind] returns the list of Open Graph meta tags
    corresponding to [kind]. *)
val to_open_graph : t -> Codex_atoms.Meta.t list
