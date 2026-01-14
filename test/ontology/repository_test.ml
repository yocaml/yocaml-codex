open Test_util
open Codex_atoms
open Codex_ontology

let yocaml_codex =
  Repository.github ~username:"yocaml" ~repository:"yocaml-codex" ()
;;

let gitlab_yocaml =
  Repository.gitlab ~username:"funkywork" ~repository:"yocaml" ()
;;

let maven_dep =
  Repository.gitlab_org
    ~name:"gitlab-examples"
    ~project:"maven"
    ~repository:"simple-maven-dep"
    ()
;;

let tuatara =
  Repository.tangled ~username:"anil.recoil.org" ~repository:"tuatara" ()
;;

let ofortune =
  Repository.sourcehut
    ~bug_tracker:`None
    ~username:"tim-ats-d"
    ~repository:"ofortune"
    ()
;;

let chawan = Repository.sourcehut ~username:"bptato" ~repository:"chawan" ()
let forgejo = Repository.codeberg ~username:"forgejo" ~repository:"forgejo" ()

let%expect_test "github homepage - 1" =
  yocaml_codex |> Repository.homepage |> dump Url.to_string;
  [%expect {| https://github.com/yocaml/yocaml-codex |}]
;;

let%expect_test "gitlab homepage - 1" =
  gitlab_yocaml |> Repository.homepage |> dump Url.to_string;
  [%expect {| https://gitlab.com/funkywork/yocaml |}]
;;

let%expect_test "gitlab homepage - 2" =
  maven_dep |> Repository.homepage |> dump Url.to_string;
  [%expect {| https://gitlab.com/gitlab-examples/maven/simple-maven-dep |}]
;;

let%expect_test "tangled homepage - 1" =
  tuatara |> Repository.homepage |> dump Url.to_string;
  [%expect {| https://tangled.sh/anil.recoil.org/tuatara |}]
;;

let%expect_test "sourcehut homepage - 1" =
  ofortune |> Repository.homepage |> dump Url.to_string;
  [%expect {| https://git.sr.ht/~tim-ats-d/ofortune |}]
;;

let%expect_test "codeberg homepage - 1" =
  forgejo |> Repository.homepage |> dump Url.to_string;
  [%expect {| https://codeberg.org/forgejo/forgejo |}]
;;

let%expect_test "sourcehut homepage - 2" =
  chawan |> Repository.homepage |> dump Url.to_string;
  [%expect {| https://git.sr.ht/~bptato/chawan |}]
;;

let%expect_test "github bugtracker - 1" =
  yocaml_codex |> Repository.bug_tracker |> dump_opt Url.to_string;
  [%expect {| https://github.com/yocaml/yocaml-codex/issues |}]
;;

let%expect_test "gitlab bugtracker - 1" =
  gitlab_yocaml |> Repository.bug_tracker |> dump_opt Url.to_string;
  [%expect {| https://gitlab.com/funkywork/yocaml/-/issues |}]
;;

let%expect_test "gitlab bugtracker - 2" =
  maven_dep |> Repository.bug_tracker |> dump_opt Url.to_string;
  [%expect
    {| https://gitlab.com/gitlab-examples/maven/simple-maven-dep/-/issues |}]
;;

let%expect_test "tangled bugtracker - 1" =
  tuatara |> Repository.bug_tracker |> dump_opt Url.to_string;
  [%expect {| https://tangled.sh/anil.recoil.org/tuatara/issues |}]
;;

let%expect_test "sourcehut bugtracker - 1" =
  ofortune |> Repository.bug_tracker |> dump_opt Url.to_string
;;

let%expect_test "sourcehut bugtracker - 2" =
  chawan |> Repository.bug_tracker |> dump_opt Url.to_string;
  [%expect {| https://todo.sr.ht/~bptato/chawan |}]
;;

let%expect_test "codeberg bugtracker - 1" =
  forgejo |> Repository.bug_tracker |> dump_opt Url.to_string;
  [%expect {| https://codeberg.org/forgejo/forgejo/issues |}]
;;

let%expect_test "github releases - 1" =
  yocaml_codex |> Repository.releases |> dump_opt Url.to_string;
  [%expect {| https://github.com/yocaml/yocaml-codex/releases |}]
;;

let%expect_test "gitlab releases - 1" =
  gitlab_yocaml |> Repository.releases |> dump_opt Url.to_string;
  [%expect {| https://gitlab.com/funkywork/yocaml/-/releases |}]
;;

let%expect_test "gitlab releases - 2" =
  maven_dep |> Repository.releases |> dump_opt Url.to_string;
  [%expect
    {| https://gitlab.com/gitlab-examples/maven/simple-maven-dep/-/releases |}]
;;

let%expect_test "tangled releases - 1" =
  tuatara |> Repository.releases |> dump_opt Url.to_string;
  [%expect {| https://tangled.sh/anil.recoil.org/tuatara/tags |}]
;;

let%expect_test "sourcehut releases - 1" =
  ofortune |> Repository.releases |> dump_opt Url.to_string;
  [%expect {| https://git.sr.ht/~tim-ats-d/ofortune/refs |}]
;;

let%expect_test "sourcehut releases - 2" =
  chawan |> Repository.releases |> dump_opt Url.to_string;
  [%expect {| https://git.sr.ht/~bptato/chawan/refs |}]
;;

let%expect_test "codeberg releases - 1" =
  forgejo |> Repository.releases |> dump_opt Url.to_string;
  [%expect {| https://codeberg.org/forgejo/forgejo/releases |}]
;;

let%expect_test "hooking bug_tracker_link - 1" =
  Repository.github
    ~bug_tracker:(Derivable.given @@ Url.https "xvw.lol")
    ~username:"xvw"
    ~repository:"capsule"
    ()
  |> Repository.bug_tracker
  |> dump_opt Url.to_string;
  [%expect {| https://xvw.lol |}]
;;

let%expect_test "Resolve files - 1" =
  yocaml_codex
  |> Repository.resolve (Yocaml.Path.rel [ "LICENSE" ])
  |> dump Url.to_string;
  [%expect {| https://github.com/yocaml/yocaml-codex/blob/main/LICENSE |}]
;;

let%expect_test "Resolve files - 2" =
  yocaml_codex
  |> Repository.resolve ~is_file:false (Yocaml.Path.rel [ "lib" ])
  |> dump Url.to_string;
  [%expect {| https://github.com/yocaml/yocaml-codex/tree/main/lib |}]
;;

let%expect_test "Resolve files - 3" =
  gitlab_yocaml
  |> Repository.resolve (Yocaml.Path.rel [ "LICENSE" ])
  |> dump Url.to_string;
  [%expect {| https://gitlab.com/funkywork/yocaml/-/blob/main/LICENSE |}]
;;

let%expect_test "Resolve files - 4" =
  gitlab_yocaml
  |> Repository.resolve ~is_file:false (Yocaml.Path.rel [ "lib" ])
  |> dump Url.to_string;
  [%expect {| https://gitlab.com/funkywork/yocaml/-/tree/main/lib |}]
;;

let%expect_test "Resolve files - 5" =
  tuatara
  |> Repository.resolve (Yocaml.Path.rel [ "LICENSE.md" ])
  |> dump Url.to_string;
  [%expect
    {| https://tangled.sh/anil.recoil.org/tuatara/blob/main/LICENSE.md |}]
;;

let%expect_test "Resolve files - 6" =
  tuatara
  |> Repository.resolve
       (Yocaml.Path.rel [ "lib"; "schema"; "tuatara_config.ml" ])
  |> dump Url.to_string;
  [%expect
    {| https://tangled.sh/anil.recoil.org/tuatara/blob/main/lib/schema/tuatara_config.ml |}]
;;

let%expect_test "Resolve files - 7" =
  tuatara
  |> Repository.resolve ~is_file:false (Yocaml.Path.rel [ "lib"; "schema" ])
  |> dump Url.to_string;
  [%expect
    {| https://tangled.sh/anil.recoil.org/tuatara/tree/main/lib/schema |}]
;;

let%expect_test "Resolve files - 8" =
  yocaml_codex
  |> Repository.resolve
       (Yocaml.Path.rel [ "lib"; "ontology"; "repository.mli" ])
  |> dump Url.to_string;
  [%expect
    {| https://github.com/yocaml/yocaml-codex/blob/main/lib/ontology/repository.mli |}]
;;

let%expect_test "Resolve files - 9" =
  ofortune
  |> Repository.resolve (Yocaml.Path.rel [ "lib"; "ofortune.mli" ])
  |> dump Url.to_string;
  [%expect
    {| https://git.sr.ht/~tim-ats-d/ofortune/tree/master/item/lib/ofortune.mli |}]
;;

let%expect_test "Resolve files - 10" =
  chawan
  |> Repository.resolve (Yocaml.Path.rel [ "adapter"; "nim.cfg" ])
  |> dump Url.to_string;
  [%expect
    {| https://git.sr.ht/~bptato/chawan/tree/master/item/adapter/nim.cfg |}]
;;

let%expect_test "Resolve files - 11" =
  chawan
  |> Repository.resolve ~is_file:false (Yocaml.Path.rel [ "adapter" ])
  |> dump Url.to_string;
  [%expect {| https://git.sr.ht/~bptato/chawan/tree/master/item/adapter |}]
;;

let%expect_test "Resolve files - 12" =
  forgejo
  |> Repository.resolve
       ~branch:"forgejo"
       (Yocaml.Path.rel [ "models"; "org.go" ])
  |> dump Url.to_string;
  [%expect
    {| https://codeberg.org/forgejo/forgejo/src/branch/forgejo/models/org.go |}]
;;

let%expect_test "Resolve files - 13" =
  forgejo
  |> Repository.resolve
       ~is_file:false
       ~branch:"forgejo"
       (Yocaml.Path.rel [ "models" ])
  |> dump Url.to_string;
  [%expect {| https://codeberg.org/forgejo/forgejo/src/branch/forgejo/models |}]
;;

let%expect_test "Resolve files - 14" =
  maven_dep
  |> Repository.resolve
       ~branch:"master"
       (Yocaml.Path.rel
          [ "src"; "test"; "java"; "com"; "example"; "dep"; "DepTest.java" ])
  |> dump Url.to_string;
  [%expect
    {| https://gitlab.com/gitlab-examples/maven/simple-maven-dep/-/blob/master/src/test/java/com/example/dep/DepTest.java |}]
;;

let%expect_test "Resolve files - 15" =
  maven_dep
  |> Repository.resolve
       ~branch:"master"
       ~is_file:false
       (Yocaml.Path.rel [ "src"; "test"; "java"; "com" ])
  |> dump Url.to_string;
  [%expect
    {| https://gitlab.com/gitlab-examples/maven/simple-maven-dep/-/tree/master/src/test/java/com |}]
;;

let%expect_test "from_data - from identifier" =
  let input =
    let open Yocaml.Data in
    string "gh/xvw/capsule"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "capsule", "kind": "github", "components":
         ["github", "xvw", "capsule"], "identifier": "github/xvw/capsule",
        "pages":
         {"home":
          {"target": "https://github.com/xvw/capsule", "scheme": "https", "host":
           "github.com", "port": null, "path": "/xvw/capsule", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://github.com/xvw/capsule/issues", "scheme": "https",
          "host": "github.com", "port": null, "path": "/xvw/capsule/issues",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://github.com/xvw/capsule/releases", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/releases", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://github.com/xvw/capsule/blob/main", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/blob/main", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from identifier" =
  let input =
    let open Yocaml.Data in
    string "github/xvw/capsule"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "capsule", "kind": "github", "components":
         ["github", "xvw", "capsule"], "identifier": "github/xvw/capsule",
        "pages":
         {"home":
          {"target": "https://github.com/xvw/capsule", "scheme": "https", "host":
           "github.com", "port": null, "path": "/xvw/capsule", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://github.com/xvw/capsule/issues", "scheme": "https",
          "host": "github.com", "port": null, "path": "/xvw/capsule/issues",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://github.com/xvw/capsule/releases", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/releases", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://github.com/xvw/capsule/blob/main", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/blob/main", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from identifier" =
  let input =
    let open Yocaml.Data in
    string "github.com/xvw/capsule"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "capsule", "kind": "github", "components":
         ["github", "xvw", "capsule"], "identifier": "github/xvw/capsule",
        "pages":
         {"home":
          {"target": "https://github.com/xvw/capsule", "scheme": "https", "host":
           "github.com", "port": null, "path": "/xvw/capsule", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://github.com/xvw/capsule/issues", "scheme": "https",
          "host": "github.com", "port": null, "path": "/xvw/capsule/issues",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://github.com/xvw/capsule/releases", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/releases", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://github.com/xvw/capsule/blob/main", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/blob/main", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from identifier" =
  let input =
    let open Yocaml.Data in
    string "gl/tezos/tezos"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "tezos", "kind": "gitlab", "components":
         ["gitlab", "tezos", "tezos"], "identifier": "gitlab/tezos/tezos",
        "pages":
         {"home":
          {"target": "https://gitlab.com/tezos/tezos", "scheme": "https", "host":
           "gitlab.com", "port": null, "path": "/tezos/tezos", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://gitlab.com/tezos/tezos/-/issues", "scheme":
           "https", "host": "gitlab.com", "port": null, "path":
           "/tezos/tezos/-/issues", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://gitlab.com/tezos/tezos/-/releases", "scheme":
           "https", "host": "gitlab.com", "port": null, "path":
           "/tezos/tezos/-/releases", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://gitlab.com/tezos/tezos/-/blob/main", "scheme":
           "https", "host": "gitlab.com", "port": null, "path":
           "/tezos/tezos/-/blob/main", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from identifier" =
  let input =
    let open Yocaml.Data in
    string "gitlab/tezos/tezos"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "tezos", "kind": "gitlab", "components":
         ["gitlab", "tezos", "tezos"], "identifier": "gitlab/tezos/tezos",
        "pages":
         {"home":
          {"target": "https://gitlab.com/tezos/tezos", "scheme": "https", "host":
           "gitlab.com", "port": null, "path": "/tezos/tezos", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://gitlab.com/tezos/tezos/-/issues", "scheme":
           "https", "host": "gitlab.com", "port": null, "path":
           "/tezos/tezos/-/issues", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://gitlab.com/tezos/tezos/-/releases", "scheme":
           "https", "host": "gitlab.com", "port": null, "path":
           "/tezos/tezos/-/releases", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://gitlab.com/tezos/tezos/-/blob/main", "scheme":
           "https", "host": "gitlab.com", "port": null, "path":
           "/tezos/tezos/-/blob/main", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from identifier" =
  let input =
    let open Yocaml.Data in
    string "gitlab.com/tezos/tezos"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "tezos", "kind": "gitlab", "components":
         ["gitlab", "tezos", "tezos"], "identifier": "gitlab/tezos/tezos",
        "pages":
         {"home":
          {"target": "https://gitlab.com/tezos/tezos", "scheme": "https", "host":
           "gitlab.com", "port": null, "path": "/tezos/tezos", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://gitlab.com/tezos/tezos/-/issues", "scheme":
           "https", "host": "gitlab.com", "port": null, "path":
           "/tezos/tezos/-/issues", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://gitlab.com/tezos/tezos/-/releases", "scheme":
           "https", "host": "gitlab.com", "port": null, "path":
           "/tezos/tezos/-/releases", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://gitlab.com/tezos/tezos/-/blob/main", "scheme":
           "https", "host": "gitlab.com", "port": null, "path":
           "/tezos/tezos/-/blob/main", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from identifier" =
  let input =
    let open Yocaml.Data in
    string "gl/gitlab-examples/maven/simple-maven-dep"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "simple-maven-dep", "kind": "gitlab", "components":
         ["gitlab", "gitlab-examples", "maven", "simple-maven-dep"],
        "identifier": "gitlab/gitlab-examples/maven/simple-maven-dep", "pages":
         {"home":
          {"target":
           "https://gitlab.com/gitlab-examples/maven/simple-maven-dep", "scheme":
           "https", "host": "gitlab.com", "port": null, "path":
           "/gitlab-examples/maven/simple-maven-dep", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target":
           "https://gitlab.com/gitlab-examples/maven/simple-maven-dep/-/issues",
          "scheme": "https", "host": "gitlab.com", "port": null, "path":
           "/gitlab-examples/maven/simple-maven-dep/-/issues", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target":
           "https://gitlab.com/gitlab-examples/maven/simple-maven-dep/-/releases",
          "scheme": "https", "host": "gitlab.com", "port": null, "path":
           "/gitlab-examples/maven/simple-maven-dep/-/releases", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target":
           "https://gitlab.com/gitlab-examples/maven/simple-maven-dep/-/blob/main",
          "scheme": "https", "host": "gitlab.com", "port": null, "path":
           "/gitlab-examples/maven/simple-maven-dep/-/blob/main", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from identifier fail because of components" =
  let input =
    let open Yocaml.Data in
    string "gh/tezos/tezos/proj"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [X]	--- Oh dear, an error has occurred ---Validation error: `test`
    Invalid shape:
      Expected: record
      Given: `"gh/tezos/tezos/proj"`---
    The backtrace is not available because the function is called (according to the [in_exception_handler] parameter) outside an exception handler. This makes the trace unspecified.
    |}]
;;

let%expect_test "from_data - from identifier" =
  let input =
    let open Yocaml.Data in
    string "sr/tim-ats-d/ofortune"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "ofortune", "kind": "sourcehut", "components":
         ["sourcehut", "tim-ats-d", "ofortune"], "identifier":
         "sourcehut/tim-ats-d/ofortune", "pages":
         {"home":
          {"target": "https://git.sr.ht/~tim-ats-d/ofortune", "scheme": "https",
          "host": "git.sr.ht", "port": null, "path": "/~tim-ats-d/ofortune",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://todo.sr.ht/~tim-ats-d/ofortune", "scheme":
           "https", "host": "todo.sr.ht", "port": null, "path":
           "/~tim-ats-d/ofortune", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://git.sr.ht/~tim-ats-d/ofortune/refs", "scheme":
           "https", "host": "git.sr.ht", "port": null, "path":
           "/~tim-ats-d/ofortune/refs", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://git.sr.ht/~tim-ats-d/ofortune/tree/master/item",
          "scheme": "https", "host": "git.sr.ht", "port": null, "path":
           "/~tim-ats-d/ofortune/tree/master/item", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from identifier" =
  let input =
    let open Yocaml.Data in
    string "sr.ht/tim-ats-d/ofortune"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "ofortune", "kind": "sourcehut", "components":
         ["sourcehut", "tim-ats-d", "ofortune"], "identifier":
         "sourcehut/tim-ats-d/ofortune", "pages":
         {"home":
          {"target": "https://git.sr.ht/~tim-ats-d/ofortune", "scheme": "https",
          "host": "git.sr.ht", "port": null, "path": "/~tim-ats-d/ofortune",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://todo.sr.ht/~tim-ats-d/ofortune", "scheme":
           "https", "host": "todo.sr.ht", "port": null, "path":
           "/~tim-ats-d/ofortune", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://git.sr.ht/~tim-ats-d/ofortune/refs", "scheme":
           "https", "host": "git.sr.ht", "port": null, "path":
           "/~tim-ats-d/ofortune/refs", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://git.sr.ht/~tim-ats-d/ofortune/tree/master/item",
          "scheme": "https", "host": "git.sr.ht", "port": null, "path":
           "/~tim-ats-d/ofortune/tree/master/item", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from identifier" =
  let input =
    let open Yocaml.Data in
    string "sourcehut/tim-ats-d/ofortune"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "ofortune", "kind": "sourcehut", "components":
         ["sourcehut", "tim-ats-d", "ofortune"], "identifier":
         "sourcehut/tim-ats-d/ofortune", "pages":
         {"home":
          {"target": "https://git.sr.ht/~tim-ats-d/ofortune", "scheme": "https",
          "host": "git.sr.ht", "port": null, "path": "/~tim-ats-d/ofortune",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://todo.sr.ht/~tim-ats-d/ofortune", "scheme":
           "https", "host": "todo.sr.ht", "port": null, "path":
           "/~tim-ats-d/ofortune", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://git.sr.ht/~tim-ats-d/ofortune/refs", "scheme":
           "https", "host": "git.sr.ht", "port": null, "path":
           "/~tim-ats-d/ofortune/refs", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://git.sr.ht/~tim-ats-d/ofortune/tree/master/item",
          "scheme": "https", "host": "git.sr.ht", "port": null, "path":
           "/~tim-ats-d/ofortune/tree/master/item", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from identifier" =
  let input =
    let open Yocaml.Data in
    string "git.sr.ht/tim-ats-d/ofortune"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "ofortune", "kind": "sourcehut", "components":
         ["sourcehut", "tim-ats-d", "ofortune"], "identifier":
         "sourcehut/tim-ats-d/ofortune", "pages":
         {"home":
          {"target": "https://git.sr.ht/~tim-ats-d/ofortune", "scheme": "https",
          "host": "git.sr.ht", "port": null, "path": "/~tim-ats-d/ofortune",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://todo.sr.ht/~tim-ats-d/ofortune", "scheme":
           "https", "host": "todo.sr.ht", "port": null, "path":
           "/~tim-ats-d/ofortune", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://git.sr.ht/~tim-ats-d/ofortune/refs", "scheme":
           "https", "host": "git.sr.ht", "port": null, "path":
           "/~tim-ats-d/ofortune/refs", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://git.sr.ht/~tim-ats-d/ofortune/tree/master/item",
          "scheme": "https", "host": "git.sr.ht", "port": null, "path":
           "/~tim-ats-d/ofortune/tree/master/item", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from record" =
  let input =
    let open Yocaml.Data in
    record
      [ "kind", string "github"
      ; "user", string "xvw"
      ; "repo", string "capsule"
      ]
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "capsule", "kind": "github", "components":
         ["github", "xvw", "capsule"], "identifier": "github/xvw/capsule",
        "pages":
         {"home":
          {"target": "https://github.com/xvw/capsule", "scheme": "https", "host":
           "github.com", "port": null, "path": "/xvw/capsule", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://github.com/xvw/capsule/issues", "scheme": "https",
          "host": "github.com", "port": null, "path": "/xvw/capsule/issues",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://github.com/xvw/capsule/releases", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/releases", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://github.com/xvw/capsule/blob/main", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/blob/main", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from record" =
  let input =
    let open Yocaml.Data in
    record
      [ "kind", string "github"
      ; "user", string "xvw"
      ; "repo", string "capsule"
      ; "bug_tracker", string "https://xvw.lol/capsule/bug-tracker.html"
      ]
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "capsule", "kind": "github", "components":
         ["github", "xvw", "capsule"], "identifier": "github/xvw/capsule",
        "pages":
         {"home":
          {"target": "https://github.com/xvw/capsule", "scheme": "https", "host":
           "github.com", "port": null, "path": "/xvw/capsule", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://xvw.lol/capsule/bug-tracker.html", "scheme":
           "https", "host": "xvw.lol", "port": null, "path":
           "/capsule/bug-tracker.html", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://github.com/xvw/capsule/releases", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/releases", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://github.com/xvw/capsule/blob/main", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/blob/main", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from unknown record" =
  let input =
    let open Yocaml.Data in
    record
      [ "repo", string "custom-capsule"
      ; "home", string "https://xvw.lol/capsule/bug-tracker.html"
      ; "blob", string "https://xvw.lol/capsule/blob/"
      ]
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "custom-capsule", "kind": "custom", "components":
         ["custom", "custom-capsule"], "identifier": "custom/custom-capsule",
        "pages":
         {"home":
          {"target": "https://xvw.lol/capsule/bug-tracker.html", "scheme":
           "https", "host": "xvw.lol", "port": null, "path":
           "/capsule/bug-tracker.html", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker": null, "releases": null, "blob_root":
          {"target": "https://xvw.lol/capsule/blob//main", "scheme": "https",
          "host": "xvw.lol", "port": null, "path": "/capsule/blob//main",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": false, "has_releases": false}}
    |}]
;;

let%expect_test "from_data - from unknown record" =
  let input =
    let open Yocaml.Data in
    record
      [ "repo", string "custom-capsule"
      ; "www", string "https://xvw.lol/capsule/"
      ; "blob", string "https://xvw.lol/capsule/blob/"
      ; "bug_tracker", string "https://xvw.lol/capsule/bug-tracker.html"
      ; "releases", string "https://xvw.lol/capsule/releases.html"
      ]
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "custom-capsule", "kind": "custom", "components":
         ["custom", "custom-capsule"], "identifier": "custom/custom-capsule",
        "pages":
         {"home":
          {"target": "https://xvw.lol/capsule/", "scheme": "https", "host":
           "xvw.lol", "port": null, "path": "/capsule/", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://xvw.lol/capsule/bug-tracker.html", "scheme":
           "https", "host": "xvw.lol", "port": null, "path":
           "/capsule/bug-tracker.html", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://xvw.lol/capsule/releases.html", "scheme": "https",
          "host": "xvw.lol", "port": null, "path": "/capsule/releases.html",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://xvw.lol/capsule/blob//main", "scheme": "https",
          "host": "xvw.lol", "port": null, "path": "/capsule/blob//main",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from uri" =
  let input =
    let open Yocaml.Data in
    string "https://github.com/xvw/capsule.git"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "capsule", "kind": "github", "components":
         ["github", "xvw", "capsule"], "identifier": "github/xvw/capsule",
        "pages":
         {"home":
          {"target": "https://github.com/xvw/capsule", "scheme": "https", "host":
           "github.com", "port": null, "path": "/xvw/capsule", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://github.com/xvw/capsule/issues", "scheme": "https",
          "host": "github.com", "port": null, "path": "/xvw/capsule/issues",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://github.com/xvw/capsule/releases", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/releases", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://github.com/xvw/capsule/blob/main", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/blob/main", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from uri" =
  let input =
    let open Yocaml.Data in
    string "git+https://github.com/xvw/capsule.git"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "capsule", "kind": "github", "components":
         ["github", "xvw", "capsule"], "identifier": "github/xvw/capsule",
        "pages":
         {"home":
          {"target": "https://github.com/xvw/capsule", "scheme": "https", "host":
           "github.com", "port": null, "path": "/xvw/capsule", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://github.com/xvw/capsule/issues", "scheme": "https",
          "host": "github.com", "port": null, "path": "/xvw/capsule/issues",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://github.com/xvw/capsule/releases", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/releases", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://github.com/xvw/capsule/blob/main", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/blob/main", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from uri" =
  let input =
    let open Yocaml.Data in
    string "https://github.com/~xvw/capsule"
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "capsule", "kind": "github", "components":
         ["github", "xvw", "capsule"], "identifier": "github/xvw/capsule",
        "pages":
         {"home":
          {"target": "https://github.com/xvw/capsule", "scheme": "https", "host":
           "github.com", "port": null, "path": "/xvw/capsule", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://github.com/xvw/capsule/issues", "scheme": "https",
          "host": "github.com", "port": null, "path": "/xvw/capsule/issues",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://github.com/xvw/capsule/releases", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/releases", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://github.com/xvw/capsule/blob/main", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/blob/main", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from uri" =
  let input =
    let open Yocaml.Data in
    record [ "repo", string "git+https://github.com/xvw/capsule.git" ]
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "capsule", "kind": "github", "components":
         ["github", "xvw", "capsule"], "identifier": "github/xvw/capsule",
        "pages":
         {"home":
          {"target": "https://github.com/xvw/capsule", "scheme": "https", "host":
           "github.com", "port": null, "path": "/xvw/capsule", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://github.com/xvw/capsule/issues", "scheme": "https",
          "host": "github.com", "port": null, "path": "/xvw/capsule/issues",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://github.com/xvw/capsule/releases", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/releases", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://github.com/xvw/capsule/blob/main", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/blob/main", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;

let%expect_test "from_data - from uri" =
  let input =
    let open Yocaml.Data in
    record
      [ "repo", string "git+https://github.com/xvw/capsule.git"
      ; "releases", string "https://all-releases.com"
      ]
  in
  input |> Repository.from_data |> dump_validation Repository.to_data;
  [%expect
    {|
    [V]	{"name": "capsule", "kind": "github", "components":
         ["github", "xvw", "capsule"], "identifier": "github/xvw/capsule",
        "pages":
         {"home":
          {"target": "https://github.com/xvw/capsule", "scheme": "https", "host":
           "github.com", "port": null, "path": "/xvw/capsule", "has_port":
           false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "bug_tracker":
          {"target": "https://github.com/xvw/capsule/issues", "scheme": "https",
          "host": "github.com", "port": null, "path": "/xvw/capsule/issues",
          "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "releases":
          {"target": "https://all-releases.com", "scheme": "https", "host":
           "all-releases.com", "port": null, "path": "/", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "blob_root":
          {"target": "https://github.com/xvw/capsule/blob/main", "scheme":
           "https", "host": "github.com", "port": null, "path":
           "/xvw/capsule/blob/main", "has_port": false, "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false},
         "has_bug_tracker": true, "has_releases": true}}
    |}]
;;
