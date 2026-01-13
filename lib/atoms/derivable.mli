(** Allows you to describe data that can be calculated without being
    specified. Unlike a simple [option] type, the user can decide
    whether to resolve it or provide a default implementation. *)

(** Describe something that can be derived. *)
type 'a t =
  [ `Derived
  | `Given of 'a
  ]

(** Describe something that can be derived and to be resolved into an
    option. *)
type 'a opt =
  [ `Derived
  | `Given of 'a
  | `None
  ]

(** [resolve f derivable] performs [f] if [derivable] is not [given]. *)
val resolve : (unit -> 'a) -> 'a t -> 'a

(** [resolve f derivable] performs [f] if [derivable] is not [given]. *)
val resolve_opt : (unit -> 'a option) -> 'a opt -> 'a option

val given : 'a -> [> `Given of 'a ]
val derived : [> `Derived ]
val none : [> `None ]
