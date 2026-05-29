(** Provides primitives for directly constructing an HTML document;
    generally, this document is refined by other, more specific
    templates. *)

(** The main idea is to start with a specific model—such as articles, for
    example—and incorporate them into a document. This allows metadata
    to be shared across multiple templates. *)

(** Describes the structure of an HTML document. *)
module Document = Document

(** A collection of functions that simplifies the creation of Open Graph
    documents by reusing as many parameters as possible from an HTML
    document. *)
module Open_graph = Open_graph

(** Reusable signatures. *)
module Intf = Intf
