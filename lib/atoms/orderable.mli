(** Set of modules that expose capabilities (primarily for use as
    functor arguments). *)

module String : Sigs.MODEL with type t = string
module Datetime : Sigs.MODEL with type t = Yocaml.Datetime.t
module Path : Sigs.MODEL with type t = Yocaml.Path.t
