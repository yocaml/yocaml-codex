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

(** Describe a regular document. *)
class t :
  ?open_graph:Codex_open_graph.Document.t
  -> ?locale:Codex_atoms.Language.t
  -> ?main_url:Codex_atoms.Url.t
  -> ?site_name:string
  -> ?canonical_url:Codex_atoms.Url.t
  -> ?tags:Codex_atoms.Tag.Set.t
  -> ?authors:Codex_ontology.Individual.Set.t
  -> ?source:Yocaml.Path.t
  -> ?cover:Codex_atoms.Media.t
  -> title:string
  -> description:string
  -> target:Yocaml.Path.t
  -> unit
  -> Intf.document

(** Describe a regular document associated to a specific content
    (usually an Archetype). *)
class with_content :
  'a Yocaml.Data.converter
  -> ?content_key:string
  -> ?open_graph:Codex_open_graph.Document.t
  -> ?locale:Codex_atoms.Language.t
  -> ?main_url:Codex_atoms.Url.t
  -> ?site_name:string
  -> ?canonical_url:Codex_atoms.Url.t
  -> ?tags:Codex_atoms.Tag.Set.t
  -> ?authors:Codex_ontology.Individual.Set.t
  -> ?source:Yocaml.Path.t
  -> ?cover:Codex_atoms.Media.t
  -> title:string
  -> description:string
  -> target:Yocaml.Path.t
  -> 'a
  ->
object
  inherit Intf.document
  method content_key : string
end

(** {1 Building document}

    Functions to facilitate the creation of specific kind of documents. *)

(** Build a concrete HTML document. *)
val make
  :  ?open_graph:Codex_open_graph.Document.t
  -> ?locale:Codex_atoms.Language.t
  -> ?main_url:Codex_atoms.Url.t
  -> ?site_name:string
  -> ?canonical_url:Codex_atoms.Url.t
  -> ?tags:Codex_atoms.Tag.Set.t
  -> ?authors:Codex_ontology.Individual.Set.t
  -> ?source:Yocaml.Path.t
  -> ?cover:Codex_atoms.Media.t
  -> title:string
  -> description:string
  -> target:Yocaml.Path.t
  -> unit
  -> t

(** Build a concrete HTML document attached wiht a content. *)
val make_with_content
  :  ('a -> Yocaml.Data.t)
  -> ?content_key:string
  -> ?open_graph:Codex_open_graph.Document.t
  -> ?locale:Codex_atoms.Language.t
  -> ?main_url:Codex_atoms.Url.t
  -> ?site_name:string
  -> ?canonical_url:Codex_atoms.Url.t
  -> ?tags:Codex_atoms.Tag.Set.t
  -> ?authors:Codex_ontology.Individual.Set.t
  -> ?source:Yocaml.Path.t
  -> ?cover:Codex_atoms.Media.t
  -> title:string
  -> description:string
  -> target:Yocaml.Path.t
  -> 'a
  -> with_content

(** {1 Normalize document} *)

(** Render a document as a list of key values. *)
val normalize : #Intf.normalizable -> (string * Yocaml.Data.t) list
