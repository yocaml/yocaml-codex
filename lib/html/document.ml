type ('configuration, 'content) t =
  { content : 'content
  ; configuration : 'configuration
  ; open_graph : Codex_open_graph.Document.t option
  ; title : string
  ; description : string
  ; tags : Codex_atoms.Tag.Set.t
  ; source : Yocaml.Path.t option
  ; target : Yocaml.Path.t
  ; cover : Codex_atoms.Media.t option
  ; authors : Codex_ontology.Individual.Set.t
  }

let make
      ?open_graph
      ?(tags = Codex_atoms.Tag.Set.empty)
      ?(authors = Codex_ontology.Individual.Set.empty)
      ?source
      ?cover
      ~title
      ~description
      ~target
      ~configuration
      ~content
      ()
  =
  { open_graph
  ; tags
  ; authors
  ; source
  ; cover
  ; title
  ; description
  ; target
  ; configuration
  ; content
  }
;;
