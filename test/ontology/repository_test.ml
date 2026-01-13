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
