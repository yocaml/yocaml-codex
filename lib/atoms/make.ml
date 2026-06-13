module Enumerable (O : Sigs.MODEL) = struct
  module Set = struct
    module STD = Stdlib.Set.Make (O)
    module COD = Set.Make (STD) (O) (O)
    include STD
    include COD
  end

  module Map = struct
    module STD = Stdlib.Map.Make (O)
    module COD = Map.Make (STD) (O) (O)
    include STD
    include COD
  end

  module Zero_or_more = Set.Zero_or_more
end
