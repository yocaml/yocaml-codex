type t =
  { local : string
  ; domain : string
  }

let to_string { local; domain } = local ^ "@" ^ domain

let concat_local local =
  local |> List.map (function `String a | `Atom a -> a) |> String.concat "."
;;

let from_address = function
  | local, (`Domain domain, []) ->
    let local = concat_local local
    and domain = String.concat "." domain in
    Ok { local; domain }
  | given ->
    let given = Emile.address_to_string given in
    Yocaml.Data.Validation.fail_with ~given "Unsupported scheme"
;;

let to_data ({ local; domain } as addr) =
  let open Yocaml.Data in
  let address = to_string addr in
  let md5 =
    address |> String.lowercase_ascii |> Digest.string |> Digest.to_hex
  in
  record
    [ "address", string address
    ; "local", string local
    ; "domain", string domain
    ; "md5", string md5
    ]
;;

let from_data =
  let open Yocaml.Data.Validation in
  string
  & fun given ->
  given
  |> Emile.address_of_string
  |> function
  | Ok address -> from_address address
  | Error (`Invalid (a, b)) ->
    let err = Format.asprintf "Invalid email address %s%s" a b in
    fail_with ~given err
;;

let compare a b =
  let a = to_string a
  and b = to_string b in
  String.compare a b
;;

let equal a b =
  let a = to_string a
  and b = to_string b in
  String.equal a b
;;

module Orderable = struct
  type nonrec t = t

  let compare = compare
  let to_data = to_data
  let from_data = from_data
end

include Make.Enumerable (Orderable)

let phrase_to_string list =
  list
  |> List.fold_left
       (fun (i, buf) -> function
          | `Dot -> succ i, buf ^ "."
          | `Word (`Atom s) | `Word (`String s) | `Encoded (s, _) ->
            let sep = if Int.equal i 0 then "" else " " in
            succ i, buf ^ sep ^ s)
       (0, "")
  |> snd
;;

let from_mailbox given =
  given
  |> Emile.of_string
  |> function
  | Ok Emile.{ name = Some name; local; domain } ->
    Result.map
      (fun email ->
         let display_name = phrase_to_string name in
         display_name, email)
      (from_address (local, domain))
  | Ok { name = None; _ } ->
    Yocaml.Data.Validation.fail_with ~given "Invalid Mailbox, missing name"
  | Error _ -> Yocaml.Data.Validation.fail_with ~given "Invalid Mailbox"
;;
