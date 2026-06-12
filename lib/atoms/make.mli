(** Functors for constructing recursive structures. *)

module Enumerable (O : Sigs.MODEL) : Sigs.SET_AND_MAP with type t := O.t
