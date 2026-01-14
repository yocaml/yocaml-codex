(** Some Test Helpers. *)

val dump : ('a -> string) -> 'a -> unit
val dump_list : ('a -> string) -> 'a list -> unit
val dump_string : string -> unit
val dump_data : 'a Yocaml.Data.converter -> 'a -> unit
val dump_opt : ('a -> string) -> 'a option -> unit
val dump_opt_list : ('a -> string) -> 'a option list -> unit

val dump_validation
  :  'a Yocaml.Data.converter
  -> 'a Yocaml.Data.Validation.validated_value
  -> unit

module Person : sig
  type t

  val make : ?first_name:string -> ?last_name:string -> string -> t

  include Codex_atoms.Sigs.COMPARABLE with type t := t
  include Yocaml.Data.S with type t := t
  include Yocaml.Data.Validation.S with type t := t
end
