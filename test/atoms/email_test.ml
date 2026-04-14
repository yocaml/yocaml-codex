open Codex_atoms
open Test_util

let%expect_test "validate an email - 1" =
  Yocaml.Data.string "xavier@xvw.lol"
  |> Email.from_data
  |> dump_validation Email.to_data;
  [%expect
    {|
    [V] {"address": "xavier@xvw.lol", "local": "xavier", "domain": "xvw.lol",
        "md5": "8ce48f56c9de1e079ceee7f064ee38f4"}
    |}]
;;

let%expect_test "validate an email - 2" =
  Yocaml.Data.string "xavier+filter@xvw.lol"
  |> Email.from_data
  |> dump_validation Email.to_data;
  [%expect
    {|
    [V] {"address": "xavier+filter@xvw.lol", "local": "xavier+filter", "domain":
         "xvw.lol", "md5": "2017a8d0eb3e4298bb27352596020904"}
    |}]
;;

let%expect_test "validate an email - 2" =
  Yocaml.Data.string "xavier+filter@xvw.lol"
  |> Email.from_data
  |> dump_validation Email.to_data;
  [%expect
    {|
    [V] {"address": "xavier+filter@xvw.lol", "local": "xavier+filter", "domain":
         "xvw.lol", "md5": "2017a8d0eb3e4298bb27352596020904"}
    |}]
;;

let%expect_test "Extract a Mailbox - 1" =
  "Xavier Van de Woestyne <xaviervdw@gmail.com>"
  |> Email.from_mailbox
  |> dump_validation Yocaml.Data.(pair string Email.to_data);
  [%expect
    {|
    [V] {"fst": "Xavier Van de Woestyne", "snd":
         {"address": "xaviervdw@gmail.com", "local": "xaviervdw", "domain":
          "gmail.com", "md5": "77147495ce1de81bd3b4d4044b8367fd"}}
    |}]
;;

let%expect_test "Extract a Mailbox - 1" =
  "The Famous XHTMLBoy <xhtmlboi@gmail.com>"
  |> Email.from_mailbox
  |> dump_validation Yocaml.Data.(pair string Email.to_data);
  [%expect
    {|
    [V] {"fst": "The Famous XHTMLBoy", "snd":
         {"address": "xhtmlboi@gmail.com", "local": "xhtmlboi", "domain":
          "gmail.com", "md5": "cd3df8ee791afc59b05feddfc4783cf2"}}
    |}]
;;
