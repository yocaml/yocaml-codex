open Codex_atoms

type t =
  | Website
  | Article of
      { published_time : Yocaml.Datetime.t
      ; updated_time : Yocaml.Datetime.t option
      ; section : string
      ; tags : Tag.Set.t
      ; authors : Url.Set.t
      }
  | Book of
      { authors : Url.Set.t
      ; isbn : Isbn.t
      ; release_date : Yocaml.Datetime.t
      ; tags : Tag.Set.t
      }
  | Profile of
      { first_name : string option
      ; last_name : string option
      ; username : string
      ; gender : Gender.t option
      }

let website = Website

let book
      ?(authors = Url.Set.empty)
      ?(tags = Tag.Set.empty)
      ~isbn
      ~release_date
      ()
  =
  Book { authors; isbn; release_date; tags }
;;

let profile ?first_name ?last_name ?gender ~username () =
  Profile { first_name; last_name; gender; username }
;;

let article
      ?updated_time
      ?(authors = Url.Set.empty)
      ?(tags = Tag.Set.empty)
      ~published_time
      ~section
      ()
  =
  Article { published_time; updated_time; section; tags; authors }
;;

let render_date date = Format.asprintf "%a" (Yocaml.Datetime.pp_rfc3339 ()) date

let to_open_graph = function
  | Website -> [ Meta.make ~name:[ "og"; "type" ] "website" ]
  | Article { published_time; updated_time; section; tags; authors } ->
    let open Meta in
    let prefix = "article" in
    let tags =
      tags
      |> Tag.Set.to_list
      |> List.map (from_value ~name:[ prefix; "tag" ] Tag.to_string)
    in
    let authors =
      authors
      |> Url.Set.to_list
      |> List.map (from_value ~name:[ prefix; "author" ] Url.to_string)
    in
    [ make ~name:[ "og"; "type" ] prefix
    ; make ~name:[ prefix; "published_time" ] (render_date published_time)
    ; from_opt ~name:[ prefix; "modified_time" ] render_date updated_time
    ; make ~name:[ prefix; "section" ] section
    ]
    @ tags
    @ authors
  | Book { authors; isbn; release_date; tags } ->
    let open Meta in
    let prefix = "book" in
    let tags =
      tags
      |> Tag.Set.to_list
      |> List.map (from_value ~name:[ prefix; "tag" ] Tag.to_string)
    in
    let authors =
      authors
      |> Url.Set.to_list
      |> List.map (from_value ~name:[ prefix; "author" ] Url.to_string)
    in
    [ make ~name:[ "og"; "type" ] prefix
    ; make ~name:[ prefix; "isbn" ] (Isbn.to_string isbn)
    ; make ~name:[ prefix; "release_date" ] (render_date release_date)
    ]
    @ tags
    @ authors
  | Profile { first_name; last_name; username; gender } ->
    let open Meta in
    let prefix = "book" in
    [ make ~name:[ "og"; "type" ] prefix
    ; make ~name:[ prefix; "username" ] username
    ; from_opt ~name:[ prefix; "first_name" ] Fun.id first_name
    ; from_opt ~name:[ prefix; "last_name" ] Fun.id last_name
    ; from_opt ~name:[ prefix; "gender" ] Gender.to_string gender
    ]
;;
