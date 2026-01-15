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

let%expect_test "to_data of social media account - 1" =
  let open Social_account in
  github ~username:"xvw" () |> dump_data to_data;
  [%expect
    {|
    {"kind": "github", "is_known": true, "is_custom": false, "username": "xvw",
    "domain":
     {"target": "https://github.com", "scheme": "https", "host": "github.com",
     "port": null, "path": "/", "has_port": false, "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false},
    "url":
     {"target": "https://github.com/xvw", "scheme": "https", "host":
      "github.com", "port": null, "path": "/xvw", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "to_data of social media account - 2" =
  let open Social_account in
  gitlab ~username:"xvw" () |> dump_data to_data;
  [%expect
    {|
    {"kind": "gitlab", "is_known": true, "is_custom": false, "username": "xvw",
    "domain":
     {"target": "https://gitlab.com", "scheme": "https", "host": "gitlab.com",
     "port": null, "path": "/", "has_port": false, "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false},
    "url":
     {"target": "https://gitlab.com/xvw", "scheme": "https", "host":
      "gitlab.com", "port": null, "path": "/xvw", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "to_data of social media account - 3" =
  let open Social_account in
  mastodon ~instance:(Url.https "merveilles.town") ~username:"xvw" ()
  |> dump_data to_data;
  [%expect
    {|
    {"kind": "mastodon", "is_known": true, "is_custom": false, "username":
     "merveilles.town/xvw", "domain":
     {"target": "https://merveilles.town", "scheme": "https", "host":
      "merveilles.town", "port": null, "path": "/", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false},
    "url":
     {"target": "https://merveilles.town/@xvw", "scheme": "https", "host":
      "merveilles.town", "port": null, "path": "/@xvw", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "to_data of social media account - 4" =
  let open Social_account in
  codeberg ~username:"kramo" () |> dump_data to_data;
  [%expect
    {|
    {"kind": "codeberg", "is_known": true, "is_custom": false, "username":
     "kramo", "domain":
     {"target": "https://codeberg.org", "scheme": "https", "host":
      "codeberg.org", "port": null, "path": "/", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false},
    "url":
     {"target": "https://codeberg.org/kramo", "scheme": "https", "host":
      "codeberg.org", "port": null, "path": "/kramo", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "to_data of social media account - 5" =
  let open Social_account in
  sourcehut ~username:"tim-ats-d" () |> dump_data to_data;
  [%expect
    {|
    {"kind": "sourcehut", "is_known": true, "is_custom": false, "username":
     "tim-ats-d", "domain":
     {"target": "https://sr.ht", "scheme": "https", "host": "sr.ht", "port":
      null, "path": "/", "has_port": false, "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false},
    "url":
     {"target": "https://sr.ht/~tim-ats-d", "scheme": "https", "host": "sr.ht",
     "port": null, "path": "/~tim-ats-d", "has_port": false, "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "to_data of social media account - 6" =
  let open Social_account in
  x ~username:"vdwxv" () |> dump_data to_data;
  [%expect
    {|
    {"kind": "x", "is_known": true, "is_custom": false, "username": "vdwxv",
    "domain":
     {"target": "https://x.com", "scheme": "https", "host": "x.com", "port":
      null, "path": "/", "has_port": false, "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false},
    "url":
     {"target": "https://x.com/vdwxv", "scheme": "https", "host": "x.com",
     "port": null, "path": "/vdwxv", "has_port": false, "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "to_data of social media account - 7" =
  let open Social_account in
  bluesky ~username:"xvw.lol" () |> dump_data to_data;
  [%expect
    {|
    {"kind": "bluesky", "is_known": true, "is_custom": false, "username":
     "xvw.lol", "domain":
     {"target": "https://bsky.app", "scheme": "https", "host": "bsky.app",
     "port": null, "path": "/", "has_port": false, "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false},
    "url":
     {"target": "https://bsky.app/profile/xvw.lol", "scheme": "https", "host":
      "bsky.app", "port": null, "path": "/profile/xvw.lol", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "to_data of social media account - 8" =
  let open Social_account in
  instagram ~username:"vdwxv" () |> dump_data to_data;
  [%expect
    {|
    {"kind": "instagram", "is_known": true, "is_custom": false, "username":
     "vdwxv", "domain":
     {"target": "https://instagram.com", "scheme": "https", "host":
      "instagram.com", "port": null, "path": "/", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false},
    "url":
     {"target": "https://instagram.com/vdwxv", "scheme": "https", "host":
      "instagram.com", "port": null, "path": "/vdwxv", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "to_data of social media account - 9" =
  let open Social_account in
  linkedin ~username:"xavdw" () |> dump_data to_data;
  [%expect
    {|
    {"kind": "linkedin", "is_known": true, "is_custom": false, "username":
     "xavdw", "domain":
     {"target": "https://linkedin.com", "scheme": "https", "host":
      "linkedin.com", "port": null, "path": "/", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false},
    "url":
     {"target": "https://linkedin.com/in/xavdw", "scheme": "https", "host":
      "linkedin.com", "port": null, "path": "/in/xavdw", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "to_data of social media account - 10" =
  let open Social_account in
  facebook ~username:"nukidoudi" () |> dump_data to_data;
  [%expect
    {|
    {"kind": "facebook", "is_known": true, "is_custom": false, "username":
     "nukidoudi", "domain":
     {"target": "https://facebook.com", "scheme": "https", "host":
      "facebook.com", "port": null, "path": "/", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false},
    "url":
     {"target": "https://facebook.com/nukidoudi", "scheme": "https", "host":
      "facebook.com", "port": null, "path": "/nukidoudi", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "to_data of social media account - 11" =
  let open Social_account in
  threads ~username:"vdwxv" () |> dump_data to_data;
  [%expect
    {|
    {"kind": "threads", "is_known": true, "is_custom": false, "username":
     "vdwxv", "domain":
     {"target": "https://threads.com", "scheme": "https", "host": "threads.com",
     "port": null, "path": "/", "has_port": false, "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false},
    "url":
     {"target": "https://threads.com/@vdwxv", "scheme": "https", "host":
      "threads.com", "port": null, "path": "/@vdwxv", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "to_data of social media account - 12" =
  let open Social_account in
  cara ~username:"vdwxv" () |> dump_data to_data;
  [%expect
    {|
    {"kind": "cara", "is_known": true, "is_custom": false, "username": "vdwxv",
    "domain":
     {"target": "https://cara.app", "scheme": "https", "host": "cara.app",
     "port": null, "path": "/", "has_port": false, "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false},
    "url":
     {"target": "https://cara.app/vdwxv", "scheme": "https", "host": "cara.app",
     "port": null, "path": "/vdwxv", "has_port": false, "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "to_data of social media account - 13" =
  let open Social_account in
  make
    ~kind:"muhokama"
    ~url:(Url.https "ring.muhokama.fun/u/xvw/")
    ~username:"xvw"
    ()
  |> dump_data to_data;
  [%expect
    {|
    {"kind": "muhokama", "is_known": false, "is_custom": true, "username":
     "xvw", "domain":
     {"target": "https://ring.muhokama.fun/", "scheme": "https", "host":
      "ring.muhokama.fun", "port": null, "path": "/", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false},
    "url":
     {"target": "https://ring.muhokama.fun/u/xvw/", "scheme": "https", "host":
      "ring.muhokama.fun", "port": null, "path": "/u/xvw/", "has_port": false,
     "query_params":
      {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
      "elements": []},
     "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "Validate a mastodon account 1" =
  let input =
    let open Yocaml.Data in
    string "@merveilles.town@xvw"
  in
  input |> Social_account.from_data |> dump_validation Social_account.to_data;
  [%expect
    {|
    [V]	{"kind": "mastodon", "is_known": true, "is_custom": false, "username":
         "merveilles.town/xvw", "domain":
         {"target": "https://merveilles.town", "scheme": "https", "host":
          "merveilles.town", "port": null, "path": "/", "has_port": false,
         "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": null, "has_query_string": false},
        "url":
         {"target": "https://merveilles.town/@xvw", "scheme": "https", "host":
          "merveilles.town", "port": null, "path": "/@xvw", "has_port": false,
         "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": null, "has_query_string": false}}
    |}]
;;

let%expect_test "Validate a mastodon account 2" =
  let input =
    let open Yocaml.Data in
    record
      [ "instance", string "https://merveilles.town"; "username", string "xvw" ]
  in
  input |> Social_account.from_data |> dump_validation Social_account.to_data;
  [%expect
    {|
    [V]	{"kind": "mastodon", "is_known": true, "is_custom": false, "username":
         "merveilles.town/xvw", "domain":
         {"target": "https://merveilles.town", "scheme": "https", "host":
          "merveilles.town", "port": null, "path": "/", "has_port": false,
         "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": null, "has_query_string": false},
        "url":
         {"target": "https://merveilles.town/@xvw", "scheme": "https", "host":
          "merveilles.town", "port": null, "path": "/@xvw", "has_port": false,
         "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": null, "has_query_string": false}}
    |}]
;;
