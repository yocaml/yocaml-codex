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

let open_graph_to_data { open_graph; _ } =
  (match open_graph with
   | Some og -> Codex_open_graph.Document.to_open_graph og
   | None -> [])
  |> Codex_atoms.Meta.to_data_list
;;

let meta_to_data { authors; tags; description; _ } =
  let open Codex_atoms.Meta in
  [ make ~name:[ "generator" ] "YOCaml"
  ; make ~name:[ "description" ] description
  ; Codex_atoms.Tag.to_meta tags
  ]
  @ Codex_ontology.Individual.to_meta authors
  |> to_data_list
;;

let normalize ?more_fields ~on_config ~on_content document =
  let open Codex_atoms in
  let open Yocaml.Data in
  let result =
    [ "meta_tag", meta_to_data document
    ; "open_graph_meta_tag", open_graph_to_data document
    ; "title", string document.title
    ; "description", string document.description
    ; "tags", Tag.Set.to_data document.tags
    ; "source", option path document.source
    ; "target", path document.target
    ; "cover", option Media.to_data document.cover
    ; "authors", Codex_ontology.Individual.Set.to_data document.authors
    ; "has_source", bool @@ Ext.Option.to_bool document.source
    ; "has_cover", bool @@ Ext.Option.to_bool document.cover
    ]
    |> Model_merge.run on_config document.configuration
    |> Model_merge.run on_content document.content
  in
  match more_fields with
  | None -> result
  | Some ms -> result |> Model_merge.run ms document
;;
