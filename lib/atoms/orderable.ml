module String = struct
  type t = string

  let compare = Stdlib.String.compare
  let to_data = Yocaml.Data.string
  let from_data = Yocaml.Data.Validation.string ~strict:false
end
