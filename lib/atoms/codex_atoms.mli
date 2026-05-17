(** Atoms are primitive elements that serve as building blocks for
    constructing more complex models (notably the {i ontology}). *)

(** {1 Enumerable structures} *)

module Set = Set
module Map = Map

(** {1 Elements} *)

module Url = Url
module Scoped_url = Scoped_url
module Isbn = Isbn
module Link = Link
module Email = Email
module Language = Language
module Meta = Meta
module Tag = Tag
module Media = Media

(** {1 Misc} *)

module Derivable = Derivable

(** {1 Reusable signatures & Misc} *)

(** A small extension of the standard library. *)
module Ext = Ext

module Sigs = Sigs
