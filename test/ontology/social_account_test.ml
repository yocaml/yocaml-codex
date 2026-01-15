open Test_util
open Codex_atoms
open Codex_ontology

let accounts =
  Social_account.
    [ github ~username:"xvw" ()
    ; gitlab ~username:"xvw" ()
    ; mastodon ~instance:(Url.https "merveilles.town") ~username:"xvw" ()
    ; codeberg ~username:"kramo" ()
    ; sourcehut ~username:"tim-ats-d" ()
    ; x ~username:"vdwxv" ()
    ; bluesky ~username:"xvw.lol" ()
    ; instagram ~username:"vdwxv" ()
    ; linkedin ~username:"xavdw" ()
    ; facebook ~username:"nukidoudi" ()
    ; threads ~username:"vdwxv" ()
    ; cara ~username:"vdwxv" ()
    ; make
        ~kind:"muhokama"
        ~url:(Url.https "ring.muhokama.fun/u/xvw/")
        ~username:"xvw"
        ()
    ]
;;

let%expect_test "Username of a social media account" =
  accounts |> List.map Social_account.username |> dump_list Fun.id;
  [%expect
    {|
    `xvw`;
    `xvw`;
    `merveilles.town/xvw`;
    `kramo`;
    `tim-ats-d`;
    `vdwxv`;
    `xvw.lol`;
    `vdwxv`;
    `xavdw`;
    `nukidoudi`;
    `vdwxv`;
    `vdwxv`;
    `xvw`
    |}]
;;

let%expect_test "Main domains of a social media account" =
  accounts |> List.map Social_account.domain |> dump_list Url.to_string;
  [%expect
    {|
    `https://github.com`;
    `https://gitlab.com`;
    `https://merveilles.town`;
    `https://codeberg.org`;
    `https://sr.ht`;
    `https://x.com`;
    `https://bsky.app`;
    `https://instagram.com`;
    `https://linkedin.com`;
    `https://facebook.com`;
    `https://threads.com`;
    `https://cara.app`;
    `https://ring.muhokama.fun/`
    |}]
;;

let%expect_test "Url of a social media account" =
  accounts |> List.map Social_account.url |> dump_list Url.to_string;
  [%expect
    {|
    `https://github.com/xvw`;
    `https://gitlab.com/xvw`;
    `https://merveilles.town/@xvw`;
    `https://codeberg.org/kramo`;
    `https://sr.ht/~tim-ats-d`;
    `https://x.com/vdwxv`;
    `https://bsky.app/profile/xvw.lol`;
    `https://instagram.com/vdwxv`;
    `https://linkedin.com/in/xavdw`;
    `https://facebook.com/nukidoudi`;
    `https://threads.com/@vdwxv`;
    `https://cara.app/vdwxv`;
    `https://ring.muhokama.fun/u/xvw/`
    |}]
;;
