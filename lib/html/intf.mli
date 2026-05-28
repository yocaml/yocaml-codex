(** All reusable signatures. *)

(** Describes an instance that can be normalized (injected into a
    template). *)
class type normalizable = object
  (** Converts the current instance into an associative list of fields. *)
  method normalize : (string * Yocaml.Data.t) list
end

(** {1 Document} *)

(** Describes the generic interface of a document. *)
class type document = object
  inherit normalizable
  method open_graph : Codex_open_graph.Document.t option
  method title : string
  method description : string
  method tags : Codex_atoms.Tag.Set.t
  method target : Yocaml.Path.t
  method source : Yocaml.Path.t option
  method cover : Codex_atoms.Media.t option
  method authors : Codex_ontology.Individual.Set.t
end
