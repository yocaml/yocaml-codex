(** Describes a Media elements like a cover (mostly for Open Graph). *)

(** {1 Structure} *)

(** The kind of cover element. *)
type kind

(** A cover element. *)
type t

(** {2 Construction} *)

(** [image ~kind url] constructs an image. *)
val image
  :  ?secure_url:Url.t
  -> ?mime_type:string
  -> ?dimension:int * int
  -> ?alt:string
  -> Scoped_url.t
  -> t

(** [video ~kind url] constructs an image. *)
val video
  :  ?secure_url:Url.t
  -> ?mime_type:string
  -> ?dimension:int * int
  -> ?alt:string
  -> Scoped_url.t
  -> t

(** {1 Yocaml Related} *)

include Yocaml.Data.S with type t := t
include Yocaml.Data.Validation.S with type t := t

(** {1 Enumerable} *)

module Set : Stdlib.Set.S with type elt = t
module Map : Stdlib.Map.S with type key = t

(** {1 Open Graph Related} *)

(** [to_open_graph cover] converts a cover element into Open Graph meta tags. *)
val to_open_graph : t -> Meta.t list
