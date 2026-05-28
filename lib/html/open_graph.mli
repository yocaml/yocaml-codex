(** Tools for describing Open Graph documents using an API that supports
    HTML document creation. *)

(** Build a document with Website open-graph associated metadata. *)
val website
  :  ?locale:Codex_atoms.Language.t
  -> main_url:Codex_atoms.Url.t
  -> site_name:string
  -> ?canonical_url:Codex_atoms.Url.t
  -> ?cover:Codex_atoms.Media.t
  -> title:string
  -> target:Yocaml.Path.t
  -> unit
  -> Codex_open_graph.Document.t

(** Build a document with Article open-graph associated metadata. *)
val article
  :  ?resolve_author:(Codex_ontology.Individual.t -> Codex_atoms.Url.t option)
  -> ?locale:Codex_atoms.Language.t
  -> main_url:Codex_atoms.Url.t
  -> site_name:string
  -> ?canonical_url:Codex_atoms.Url.t
  -> ?cover:Codex_atoms.Media.t
  -> ?tags:Codex_atoms.Tag.Set.t
  -> ?authors:Codex_ontology.Individual.Set.t
  -> ?updated_time:Yocaml.Datetime.t
  -> title:string
  -> target:Yocaml.Path.t
  -> section:string
  -> published_time:Yocaml.Datetime.t
  -> unit
  -> Codex_open_graph.Document.t

(** Build a document with Book open-graph associated metadata. *)
val book
  :  ?resolve_author:(Codex_ontology.Individual.t -> Codex_atoms.Url.t option)
  -> ?locale:Codex_atoms.Language.t
  -> main_url:Codex_atoms.Url.t
  -> site_name:string
  -> ?canonical_url:Codex_atoms.Url.t
  -> ?cover:Codex_atoms.Media.t
  -> ?tags:Codex_atoms.Tag.Set.t
  -> ?authors:Codex_ontology.Individual.Set.t
  -> title:string
  -> target:Yocaml.Path.t
  -> isbn:Codex_atoms.Isbn.t
  -> release_date:Yocaml.Datetime.t
  -> unit
  -> Codex_open_graph.Document.t

(** Build a document with Profile open-graph associated metadata. *)
val profile
  :  ?locale:Codex_atoms.Language.t
  -> main_url:Codex_atoms.Url.t
  -> site_name:string
  -> ?canonical_url:Codex_atoms.Url.t
  -> ?cover:Codex_atoms.Media.t
  -> title:string
  -> target:Yocaml.Path.t
  -> individual:Codex_ontology.Individual.t
  -> unit
  -> Codex_open_graph.Document.t
