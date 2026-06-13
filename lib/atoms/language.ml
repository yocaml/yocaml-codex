type t =
  { code : Iso639.Lang.t
  ; region : string option
  }

let common_language_names =
  Map.String.of_list
    [ "english", "en"
    ; "chinese", "zh"
    ; "hindi", "hi"
    ; "spanish", "es"
    ; "french", "fr"
    ; "arabic", "ar"
    ; "portuguese", "pt"
    ; "russian", "ru"
    ; "german", "de"
    ]
;;

let default_regions =
  Map.String.of_list
    [ "en", "US"
    ; "zh", "CN"
    ; "hi", "IN"
    ; "es", "ES"
    ; "fr", "FR"
    ; "ar", "SA"
    ; "pt", "BR"
    ; "ru", "RU"
    ; "de", "DE"
    ]
;;

let normalize_code s =
  let s = String.trim s |> String.lowercase_ascii in
  match Iso639.Lang.of_iso639p1 s with
  | Some lang -> Some lang
  | None ->
    (match Iso639.Lang.of_iso639p2 s with
     | Some lang -> Some lang
     | None ->
       (match Map.String.find_opt s common_language_names with
        | Some iso1 -> Iso639.Lang.of_iso639p1 iso1
        | None -> None))
;;

let default_region code region =
  match region with
  | Some _ -> region
  | None ->
    let code_str =
      match Iso639.Lang.to_iso639p1 code with
      | Some c -> c
      | None -> Iso639.Lang.to_string code
    in
    Map.String.find_opt code_str default_regions
;;

let make code region =
  let region = default_region code region in
  { code; region }
;;

let from_string s =
  let open Yocaml.Data.Validation in
  match Stdlib.String.split_on_char '-' s with
  | [ raw_code ] ->
    (match normalize_code raw_code with
     | Some code -> Ok (make code None)
     | None -> fail_with ~given:raw_code "Unknown language")
  | [ raw_code; region ] ->
    (match normalize_code raw_code with
     | Some code -> Ok (make code (Some region))
     | None -> fail_with ~given:raw_code "Unknown language")
  | _ -> fail_with ~given:s "Invalid language format"
;;

let from_record =
  let open Yocaml.Data.Validation in
  record (fun fields ->
    let+ code =
      req
        fields
        "code"
        ~alt:[ "language"; "lang" ]
        (string & where_opt normalize_code)
    and+ region = opt fields "region" ~alt:[ "country" ] string in
    make code region)
;;

let guard s =
  match from_string s with
  | Ok x -> x
  | Error _ ->
    (* NOTE: Should never happen *)
    failwith ("lang error: " ^ s)
;;

let fr = guard "french"
let en_us = guard "english"
let en_uk = guard "en-UK"

let from_data =
  let open Yocaml.Data.Validation in
  from_record / (string & from_string)
;;

let to_code { code; _ } =
  match Iso639.Lang.to_iso639p1 code with
  | Some c -> c
  | None -> Iso639.Lang.to_string code
;;

let to_string ({ region; _ } as lang) =
  let code = to_code lang in
  match region with
  | None -> code
  | Some region -> code ^ "-" ^ region
;;

let to_data ({ code; region } as lang) =
  let open Yocaml.Data in
  let code_str =
    match Iso639.Lang.to_iso639p1 code with
    | Some c -> c
    | None -> Iso639.Lang.to_string code
  in
  let scope =
    match Iso639.Lang.scope code with
    | `Individual -> "individual"
    | `Macro -> "macro"
    | `Special -> "special"
  in
  record
    [ "tag", string (to_string lang)
    ; "code", string code_str
    ; "iso639p1", option string (Iso639.Lang.to_iso639p1 code)
    ; "iso639p2", option string (Iso639.Lang.to_iso639p2t code)
    ; "scope", string scope
    ; "is_macro", bool (Iso639.Lang.scope code = `Macro)
    ; "region", Ext.Option.to_data string region
    ]
;;

let equal a b =
  Iso639.Lang.equal a.code b.code && Option.equal String.equal a.region b.region
;;

let compare a b =
  let c = Iso639.Lang.compare a.code b.code in
  if c <> 0 then c else Option.compare String.compare a.region b.region
;;

module Orderable = struct
  type nonrec t = t

  let compare = compare
  let to_data = to_data
  let from_data = from_data
end

include Make.Enumerable (Orderable)
