type t =
  { code : string
  ; region : string option
  }

let normalize_code s =
  let s = String.trim s |> String.lowercase_ascii in
  match Iso639.Lang.of_string s with
  | Some lang -> Some (Iso639.Lang.to_string lang)
  | None -> None
;;

let make code region =
  { code; region }
;;

let from_string s =
  let open Yocaml.Data.Validation in
  match Stdlib.String.split_on_char '-' s with
  | [ raw_code ] -> (
      match normalize_code raw_code with
      | Some code -> Ok (make code None)
      | None ->
          fail_with ~given:raw_code "Unknown language")
  | [ raw_code; region ] -> (
      match normalize_code raw_code with
      | Some code -> Ok (make code (Some region))
      | None ->
          fail_with ~given:raw_code "Unknown language")
  | _ ->
      fail_with ~given:s "Invalid language format"
;;


let from_record =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let+ code =
      req fields "code" ~alt:[ "language"; "lang" ]
        (string & where_opt normalize_code)
    and+ region =
      opt fields "region" ~alt:[ "country" ] string
    in
    make code region)
;;

let from_data =
  let open Yocaml.Data.Validation in
  from_record / (string & from_string)
;;

let to_string { code; region } =
  match region with
  | None -> code
  | Some region -> code ^ "-" ^ region
;;

let to_data ({ code; region } as lang) =
  let open Yocaml.Data in
  record
    [ "tag", string (to_string lang)
    ; "code", string code
    ; "region", option string region
    ; "has_region", bool (Option.is_some region)
    ]
;;

let compare a b =
  String.compare (to_string a) (to_string b)
;;

let equal a b =
  String.equal (to_string a) (to_string b)
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
