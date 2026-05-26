type t =
  | Male of string list
  | Female of string list
  | Other of string * string list

let to_string = function
  | Male _ -> "male"
  | Female _ -> "female"
  | Other (s, _) -> s
;;

let nouns_of nouns =
  List.map (fun x -> x |> String.trim |> String.lowercase_ascii) nouns
;;

let male ?(pronouns = [ "he"; "him"; "his" ]) () = Male (nouns_of pronouns)

let female ?(pronouns = [ "she"; "her"; "hers" ]) () =
  Female (nouns_of pronouns)
;;

let other ?(pronouns = []) s = Other (s, nouns_of pronouns)

let pronouns = function
  | Male p | Female p | Other (_, p) -> p
;;

let with_nouns n = function
  | Male _ -> Male n
  | Female _ -> Female n
  | Other (s, _) -> Other (s, n)
;;

let to_data gender =
  let pronouns = pronouns gender in
  let name = to_string gender in
  let has_pronouns = not (List.is_empty pronouns) in
  let open Yocaml.Data in
  record
    [ "name", string name
    ; "has_pronouns", bool has_pronouns
    ; ( "pronouns"
      , record
          [ "has", bool has_pronouns
          ; "all", list_of string pronouns
          ; "repr", string @@ String.concat "/" pronouns
          ] )
    ]
;;

let from_string =
  let open Yocaml.Data.Validation in
  string $ String.trim $ String.lowercase_ascii
  & String.not_blank
    $ function
    | "male" -> male ()
    | "female" -> female ()
    | s -> other s
;;

let from_record =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let+ gender = req fields "name" ~alt:[ "gender"; "kind" ] from_string
    and+ nouns =
      Derivable.opt
        fields
        "pronouns"
        ~alt:[ "nouns" ]
        ((string $ Stdlib.String.split_on_char '/') / list_of string $ nouns_of)
    in
    let pronouns =
      nouns
      |> Derivable.resolve_opt (fun () -> Some (pronouns gender))
      |> Option.value ~default:[]
    in
    with_nouns pronouns gender)
;;

let from_data =
  let open Yocaml.Data.Validation in
  from_string / from_record
;;

let compare a b =
  let na = to_string a
  and nb = to_string b in
  let c = String.compare na nb in
  if Int.equal 0 c
  then (
    let a = pronouns a
    and b = pronouns b in
    List.compare String.compare a b)
  else c
;;

let equal a b =
  let x = compare a b in
  Int.equal 0 x
;;

module Orderable = struct
  type nonrec t = t

  let compare = compare
  let to_data = to_data
  let from_data = from_data
end

module Set = struct
  module S = Stdlib.Set.Make (Orderable)
  include S
  include Set.Make (S) (Orderable) (Orderable)
end

module Map = struct
  module S = Stdlib.Map.Make (Orderable)
  include S
  include Map.Make (S) (Orderable) (Orderable)
end
