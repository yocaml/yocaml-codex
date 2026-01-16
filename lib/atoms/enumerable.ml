let to_data ~kind ~cardinal ~is_empty on_element value =
  let open Yocaml.Data in
  let empty = is_empty value in
  record
    [ "kind", string kind
    ; "length", int (cardinal value)
    ; "is_empty", bool empty
    ; "is_not_empty", bool (not empty)
    ; "elements", on_element value
    ]
;;

let from_data ~from_list validation =
  let open Yocaml.Data.Validation in
  list_of validation
  / record (fun fields ->
    req
      fields
      "elements"
      ~alt:[ "set"; "values"; "all"; "map" ]
      (list_of validation))
  $ from_list
;;
