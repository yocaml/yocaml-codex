(** Describes a full HTML Document. The main goal is to be used as an
    entry point to be produce concrete HTML pages. *)

(** [Document] are never validated but always normalized. *)

(** {1 Structure} *)

(** Typically, Atoms and ontologies are described as records and are
    relatively static. This is because it is assumed that we would not
    want to extend them. However, for documents (and likely some
    complex archetypes), we want to give users the freedom to add
    fields without having to deal with awkward merge solutions;
    therefore, we rely on the object model to give users the freedom
    to extend a model. *)

class t :
  ?open_graph:Codex_open_graph.Document.t
  -> ?tags:Codex_atoms.Tag.Set.t
  -> ?authors:Codex_ontology.Individual.Set.t
  -> ?source:Yocaml.Path.t
  -> ?cover:Codex_atoms.Media.t
  -> title:string
  -> description:string
  -> target:Yocaml.Path.t
  -> unit
  ->
object
  inherit Intf.document

  (** Methods to be used in extension *)

  method normalize_meta_tag : Codex_atoms.Meta.t list
  method normalize_open_graph_tag : Codex_atoms.Meta.t list
end

(** {1 Building document}

    Functions to facilitate the creation of specific kind of documents. *)

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
  -> unit
  -> t

(** {2 Open Graph specified}

    Document type associated with Open Graph data. *)
