(** Ontology describes a set of reusable components/models for
    building rich page/document archetypes.

    All of these elements are constructed using the models described
    in [yocaml-codex.atoms]. *)

(** {1 Generic}

    All elements serving as bases (such as minimal representations). *)

module Individual = Individual

(** {1 Technical}

    All elements of ontology that are technical (and describe
    technical objects). *)

module Repository = Repository
module Social_account = Social_account
