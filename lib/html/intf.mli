(** All reusable signatures. *)

(** Describes an instance that can be normalized (injected into a
    template). *)
class type normalizable = object
  (** Converts the current instance into an associative list of fields. *)
  method normalize : (string * Yocaml.Data.t) list

  (** Returns the normalization as a Record. *)
  method to_data : Yocaml.Data.t
end

(** {1 Document} *)

(** Describes the generic interface of a document. *)
class type document = object
  inherit normalizable
  method title : string
  method description : string
  method tags : Codex_atoms.Tag.Set.t
  method target : Yocaml.Path.t
  method source : Yocaml.Path.t option
  method cover : Codex_atoms.Media.t option
  method authors : Codex_ontology.Individual.Set.t
  method open_graph : Codex_open_graph.Document.t option
  method locale : Codex_atoms.Language.t option
  method main_url : Codex_atoms.Url.t option
  method site_name : string option
  method canonical_url : Codex_atoms.Url.t option
  method normalize_meta_tag : Codex_atoms.Meta.t list
  method normalize_open_graph_tag : Codex_atoms.Meta.t list
end
