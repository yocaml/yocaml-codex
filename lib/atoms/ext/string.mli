(** Additional functions for strings. *)

(** [from_char c] builds a string based on a character. *)
val from_char : char -> string

(** [char_at n s] returns the nth ([n]) character of the string [s]. *)
val char_at : int -> string -> char option

(** [from_list f l] Converts an arbitrary list to a string, [l], by
    concatenating each application of [f]. *)
val from_list : ('a -> string) -> 'a list -> string

(** [from_filtered_list f l] Converts an arbitrary list to a string, [l], by
    concatenating each application of [f] that leads to [Some]. *)
val from_filtered_list : ('a -> string option) -> 'a list -> string

(** [from_char_list l] converts a list of characters into a string. *)
val from_char_list : char list -> string

(** [to_list f s] converts a string [s] to an arbitrary list. *)
val to_list : (char -> 'a) -> string -> 'a list

(** [to_char_list s] converts a string [s] to a list of char. *)
val to_char_list : string -> char list

(** [concat_with ~sep f l] Concatenates an arbitrary list, [l] using [sep]. *)
val concat_with : sep:string -> ('a -> string) -> 'a list -> string

(** [ltrim_when p s] trim using [p] has predicate to remove char. *)
val ltrim_when : (char -> bool) -> string -> string

(** [rtrim_when p s] trim using [p] has predicate to remove char. *)
val rtrim_when : (char -> bool) -> string -> string

(** [trim_when p s] trim using [p] has predicate to remove char. *)
val trim_when : (char -> bool) -> string -> string

(** [remove_leading_char_when pred s] remove the first char of [s] if it
    satisfy [pred]. *)
val remove_leading_char_when : (char -> bool) -> string -> string

(** [remove_leading_arobase s] remove the leading [@]. *)
val remove_leading_arobase : string -> string

(** [remove_leading_hash s] remove the leading [#]. *)
val remove_leading_hash : string -> string

(** [remove_leading_dot s] remove the leading [.]. *)
val remove_leading_dot : string -> string

(** [may_prepend c s] is concat [c] if [s] does not start with [c]. *)
val may_prepend : char -> string -> string
