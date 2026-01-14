type 'a t =
  [ `Derived
  | `Given of 'a
  ]

type 'a opt =
  [ 'a t
  | `None
  ]

let resolve f = function
  | `Derived -> f ()
  | `Given x -> x
;;

let resolve_opt f = function
  | `Derived -> f ()
  | `Given x -> Some x
  | `None -> None
;;

let given x = `Given x
let derived = `Derived
let none = `None

let optional fields name handler =
  let open Yocaml.Data.Validation in
  let a = string & String.equal "<none>" & const none
  and b = handler $ given in
  optional_or ~default:derived fields name (a / b)
;;

let to_option = function
  | `Given x -> Some x
  | `None | `Derived -> None
;;
