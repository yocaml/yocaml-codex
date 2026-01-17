(** Somn random function (notably for validation). *)

val in_str_enum : ?case_sensitive:bool -> string list -> string -> bool
val split_path : string -> string list
val as_name : string Yocaml.Data.validable
val add_scheme : ?scheme:string -> string -> string
val ltrim_path : string list -> string list
