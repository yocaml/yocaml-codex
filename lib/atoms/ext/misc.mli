(** Somn random function (notably for validation). *)

(** [in_str_enum ?case_sensitive xs x] checks if [x] is include in [xs]. *)
val in_str_enum : ?case_sensitive:bool -> string list -> string -> bool

(** [split_path s] split [s], removing some chars. *)
val split_path : string -> string list

(** A validator that checks if something looks like a name (not blank)
    and without denominating chars like [@] and [~]. *)
val from_handle_to_name : string Yocaml.Data.validable

(** Sanitize a name. *)
val as_name : string Yocaml.Data.validable

(** [add_scheme ?scheme s] adds the [scheme] to [s] if there is no
    scheme. *)
val add_scheme : ?scheme:string -> string -> string

(** [ltrim_path xs] remove leading empty sectin in [xs]. *)
val ltrim_path : string list -> string list
