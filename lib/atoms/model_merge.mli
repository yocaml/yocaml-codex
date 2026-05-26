(** A strategy for merging existing models (key value lists). *)

(** {1 Types} *)

type ('key, 'value, 'ext) t =
  [ `Concat of 'ext -> ('key * 'value) list
  | `Nest of 'key * ('ext -> 'value)
  ]

(** {1 Builder} *)

(** [concat f] will concat the given model to the current model at the
    same level. *)
val concat : ('ext -> ('key * 'value) list) -> ('key, 'value, 'ext) t

(** [nest ~key f] will nest the result into a given key. *)
val nest : key:'key -> ('ext -> 'value) -> ('key, 'value, 'ext) t

(** {1 Run strategy} *)

(** [run strategy value list] compute the next list based on [strategy]
    and [x]. *)
val run
  :  ('key, 'value, 'ext) t
  -> 'ext
  -> ('key * 'value) list
  -> ('key * 'value) list
