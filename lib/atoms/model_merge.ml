type ('key, 'value, 'ext) t =
  [ `Concat of 'ext -> ('key * 'value) list
  | `Nest of 'key * ('ext -> 'value)
  ]

let concat f = `Concat f
let nest ~key f = `Nest (key, f)

let run k x assoc =
  match k with
  | `Concat f -> assoc @ f x
  | `Nest (key, f) -> (key, f x) :: assoc
;;
