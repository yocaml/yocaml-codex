(** Some helpers to deal with option. *)

val unit : 'a option -> unit option
val from_bool : bool -> unit option
val to_bool : 'a option -> bool
val zip : 'a option -> 'b option -> ('a * 'b) option
val may_perform : ('a -> 'b -> 'b) -> 'b -> 'a option -> 'b

module Syntax : sig
  val ( let+ ) : 'a option -> ('a -> 'b) -> 'b option
  val ( let* ) : 'a option -> ('a -> 'b option) -> 'b option
  val ( and+ ) : 'a option -> 'b option -> ('a * 'b) option
  val ( and* ) : 'a option -> 'b option -> ('a * 'b) option
end

module Infix : sig
  val ( <$> ) : ('a -> 'b) -> 'a option -> 'b option
  val ( <$ ) : 'a -> 'b option -> 'a option
  val ( $> ) : 'a option -> 'b -> 'b option
  val ( >>= ) : 'a option -> ('a -> 'b option) -> 'b option
  val ( =<< ) : ('a -> 'b option) -> 'a option -> 'b option
  val ( >|= ) : 'a option -> ('a -> 'b) -> 'b option
  val ( <*> ) : ('a -> 'b) option -> 'a option -> 'b option
  val ( <|> ) : 'a option -> 'a option -> 'a option
end

include module type of Infix
include module type of Syntax

(** An alternative representation of [Option], instead of using [unboxed]
    option ([x | Null] that need to have [has_fields] it use a record
    with two fields: [{value: T; exists: bool}]). *)
val to_data : 'a Yocaml.Data.converter -> 'a option Yocaml.Data.converter
