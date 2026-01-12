open Test_util
open Codex_ontology

let yocaml_codex =
  Repository.github ~username:"yocaml" ~repository:"yocaml-codex" ()
;;

let%expect_test "dump github repository" =
  yocaml_codex |> dump_data Repository.to_data;
  [%expect
    {|
    {"name": "yocaml-codex", "home":
     {"target": "https://github.com/yocaml/yocaml-codex", "scheme": "https",
     "host": "github.com", "port": null, "path": "/yocaml/yocaml-codex",
     "has_port": false, "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false},
    "bug_tracker":
     {"target": "https://github.com/yocaml/yocaml-codex/issues", "scheme":
      "https", "host": "github.com", "port": null, "path":
      "/yocaml/yocaml-codex/issues", "has_port": false, "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false}}
    |}]
;;
