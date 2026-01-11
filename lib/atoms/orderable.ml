module String = struct
  type t = string

  let compare = Stdlib.String.compare
  let to_data = Yocaml.Data.string
  let from_data = Yocaml.Data.Validation.string ~strict:false
end

module Datetime = struct
  type t = Yocaml.Datetime.t

  let compare = Yocaml.Datetime.compare
  let to_data = Yocaml.Datetime.to_data
  let from_data = Yocaml.Datetime.from_data
end

module Path = struct
  type t = Yocaml.Path.t

  let compare = Yocaml.Path.compare
  let to_data = Yocaml.Data.path
  let from_data = Yocaml.Data.Validation.path
end
