let infer_canonical_url main_url target = function
  | Some c -> c
  | None -> Codex_atoms.Url.resolve target main_url
;;

let website ?locale ~main_url ~site_name ?canonical_url ?cover ~title ~target ()
  =
  let canonical_url = infer_canonical_url main_url target canonical_url in
  let open Codex_open_graph in
  let kind = Kind.website in
  Document.make ~kind ?locale ?cover ~title ~site_name ~url:canonical_url ()
;;

let resolve_authors resolve_author authors =
  Codex_ontology.Individual.Set.fold
    (fun author set ->
       match resolve_author author with
       | None -> set
       | Some url -> Codex_atoms.Url.Set.add url set)
    authors
    Codex_atoms.Url.Set.empty
;;

let article
      ?(resolve_author = fun _ -> None)
      ?locale
      ~main_url
      ~site_name
      ?canonical_url
      ?cover
      ?tags
      ?(authors = Codex_ontology.Individual.Set.empty)
      ?updated_time
      ~title
      ~target
      ~section
      ~published_time
      ()
  =
  let canonical_url = infer_canonical_url main_url target canonical_url in
  let authors = resolve_authors resolve_author authors in
  let open Codex_open_graph in
  let kind =
    Kind.article ?updated_time ?tags ~section ~authors ~published_time ()
  in
  Document.make ~kind ?locale ?cover ~title ~site_name ~url:canonical_url ()
;;

let book
      ?(resolve_author = fun _ -> None)
      ?locale
      ~main_url
      ~site_name
      ?canonical_url
      ?cover
      ?tags
      ?(authors = Codex_ontology.Individual.Set.empty)
      ~title
      ~target
      ~isbn
      ~release_date
      ()
  =
  let canonical_url = infer_canonical_url main_url target canonical_url in
  let authors = resolve_authors resolve_author authors in
  let open Codex_open_graph in
  let kind = Kind.book ?tags ~authors ~isbn ~release_date () in
  Document.make ~kind ?locale ?cover ~title ~site_name ~url:canonical_url ()
;;

let profile
      ?locale
      ~main_url
      ~site_name
      ?canonical_url
      ?cover
      ~title
      ~target
      ~individual
      ()
  =
  let canonical_url = infer_canonical_url main_url target canonical_url in
  let open Codex_open_graph in
  let kind =
    Kind.profile
      ?first_name:(Codex_ontology.Individual.first_name individual)
      ?last_name:(Codex_ontology.Individual.last_name individual)
      ?gender:(Codex_ontology.Individual.gender individual)
      ~username:(Codex_ontology.Individual.display_name individual)
      ()
  in
  Document.make ~kind ?locale ?cover ~title ~site_name ~url:canonical_url ()
;;
