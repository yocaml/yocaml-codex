(** Describes a full HTML Document. The main goal is to be used as an
    entry point to be produce concrete HTML pages. *)

(** [Document] are never validated but always normalized. *)

(** {1 Structure} *)

(** The type is parametrized by a potential configuration and by a
    specific conteent (i.e, an Article, a regular page etc.) *)
type ('configuration, 'content) t

(** {1 Building documents} *)

(** Build a concrete HTML document. *)
val make
  :  ?open_graph:Codex_open_graph.Document.t
  -> ?tags:Codex_atoms.Tag.Set.t
  -> ?authors:Codex_ontology.Individual.Set.t
  -> ?source:Yocaml.Path.t
  -> ?cover:Codex_atoms.Media.t
  -> title:string
  -> description:string
  -> target:Yocaml.Path.t
  -> configuration:'configuration
  -> content:'content
  -> unit
  -> ('configuration, 'content) t

(** {1 Yocaml Related} *)

(** Render a document as a templates set of metadata. You can use
    [more_fields] to compute more records fields on the document. *)
val normalize
  :  ?more_fields:
       ( string
         , Yocaml.Data.t
         , ('configuration, 'content) t )
         Codex_atoms.Model_merge.t
  -> on_config:(string, Yocaml.Data.t, 'configuration) Codex_atoms.Model_merge.t
  -> on_content:(string, Yocaml.Data.t, 'content) Codex_atoms.Model_merge.t
  -> ('configuration, 'content) t
  -> (string * Yocaml.Data.t) list
