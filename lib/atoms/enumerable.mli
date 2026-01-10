(** {i Low-level} validation/projection for handling enumerables (such
    as {!module:Stdlib.Map}, {!module:Stdlib.Set}, etc.).

    The purpose of this module is to share field names across
    different enumerable structures ({b but not to be used
    directly}). *)

(** [to_data ~kind ~cardinal ~is_empty validator] converts an
    enumerable structure into {!type:Yocaml.Data.t}.

    - [kind] is a string to define the kind of the data, ie: [map],
      [set].
    - [cardinal] is a function to compute the number of element in the
      structure.
    - [is_empty] is a function to compute if the structure is empty or
      not.  It can be done using [cardinal x = 0], but usually
      [is_empty] can be more efficient. *)
val to_data
  :  kind:string
  -> cardinal:('a -> int)
  -> is_empty:('a -> bool)
  -> 'a Yocaml.Data.converter
  -> 'a Yocaml.Data.converter

(** [from_data ~from_list validator] validate a value
    {!type:Yocaml.Data.t} into a list and lift the list into the
    dedicated enumerable using [from_list]. *)
val from_data
  :  from_list:('a list -> 'b)
  -> 'a Yocaml.Data.validable
  -> 'b Yocaml.Data.validable
