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
