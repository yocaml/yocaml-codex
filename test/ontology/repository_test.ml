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
  [%expect {| https://gitlab.com/gitlab-examples/maven/simple-maven-dep/-/issues |}]
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
