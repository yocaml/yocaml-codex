type t =
  | Path of Yocaml.Path.t
  | Url of Url.t

let internal p = Path p
let url u = Url u

let to_string = function
  | Url u -> Url.to_string u
  | Path p -> Yocaml.Path.to_string p
;;

let compare a b =
  match a, b with
  | Path _, Url _ -> -1
  | Url _, Path _ -> 1
  | Path a, Path b -> Yocaml.Path.compare a b
  | Url a, Url b -> Url.compare a b
;;

let equal a b = Int.equal 0 (compare a b)

let from_data =
  let open Yocaml.Data.Validation in
  ((function
     | Yocaml.Data.String s as x ->
       if Stdlib.String.contains s ':'
       then
         (* KLUDGE: hmmm *)
         Yocaml.Data.Validation.fail_with ~given:s "probably an URL"
       else Ok x
     | x -> Ok x)
   & path $ internal)
  / (Url.from_data $ url)
;;

let to_data u =
  let open Yocaml.Data in
  match u with
  | Path p -> record [ "kind", string "internal"; "target", path p ]
  | Url u ->
    record
      [ "kind", string "external"
      ; "target", string (Url.to_string u)
      ; "url", Url.to_data u
      ]
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
