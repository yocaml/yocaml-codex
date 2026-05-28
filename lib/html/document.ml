class t
  ?open_graph
  ?(tags = Codex_atoms.Tag.Set.empty)
  ?(authors = Codex_ontology.Individual.Set.empty)
  ?source
  ?cover
  ~title
  ~description
  ~target
  () =
  object (self : #Intf.document)
    val open_graph = open_graph
    val tags = tags
    val authors = authors
    val source = source
    val cover = cover
    val title = title
    val description = description
    val target = target
    method open_graph = open_graph
    method title = title
    method description = description
    method tags = tags
    method target = target
    method source = source
    method cover = cover
    method authors = authors

    method normalize_open_graph_tag =
      match open_graph with
      | Some og -> Codex_open_graph.Document.to_open_graph og
      | None -> []

    method normalize_meta_tag =
      let open Codex_atoms.Meta in
      [ make ~name:[ "generator" ] "YOCaml"
      ; make ~name:[ "description" ] description
      ; Codex_atoms.Tag.to_meta tags
      ]

    method normalize =
      let open Codex_atoms in
      let open Yocaml.Data in
      [ "meta_tag", Meta.to_data_list self#normalize_meta_tag
      ; "open_graph_tag", Meta.to_data_list self#normalize_open_graph_tag
      ; "title", string self#title
      ; "description", string self#description
      ; "tags", Tag.Set.to_data self#tags
      ; "target", path self#target
      ; "source", option path self#source
      ; "cover", option Media.to_data self#cover
      ; "authors", Codex_ontology.Individual.Set.to_data self#authors
      ; "has_cover", bool @@ Ext.Option.to_bool self#cover
      ; "has_source", bool @@ Ext.Option.to_bool self#source
      ]
  end

let make
      ?open_graph
      ?tags
      ?authors
      ?source
      ?cover
      ~title
      ~description
      ~target
      ()
  =
  new t ?open_graph ?tags ?authors ?source ?cover ~title ~description ~target ()
;;
