open Test_util
open Codex_atoms

let image_cover =
  Media.image ~alt:"An example image" (Scoped_url.https "example.com/image.png")
;;

let image_cover_with_dimensions =
  Media.image ~dimension:(1200, 630) (Scoped_url.https "example.com/cover.png")
;;

let video_cover =
  Media.video ~mime_type:"video/mp4" (Scoped_url.https "example.com/video.mp4")
;;

let secure_image_cover =
  Media.image
    ~secure_url:(Url.https "cdn.example.com/image.png")
    (Scoped_url.http "example.com/image.png")
;;

let%expect_test "image to_open_graph" =
  image_cover |> Media.to_open_graph |> dump_data Meta.to_data_list;
  [%expect
    {|
    [{"name": "og:image", "content": "https://example.com/image.png"},
    {"name": "og:image:alt", "content": "An example image"}]
    |}]
;;

let%expect_test "image with dimensions to_open_graph" =
  image_cover_with_dimensions
  |> Media.to_open_graph
  |> dump_data Meta.to_data_list;
  [%expect
    {|
    [{"name": "og:image", "content": "https://example.com/cover.png"},
    {"name": "og:image:width", "content": "1200"},
    {"name": "og:image:height", "content": "630"}]
    |}]
;;

let%expect_test "video to_open_graph" =
  video_cover |> Media.to_open_graph |> dump_data Meta.to_data_list;
  [%expect
    {|
    [{"name": "og:video", "content": "https://example.com/video.mp4"},
    {"name": "og:video:type", "content": "video/mp4"}]
    |}]
;;

let%expect_test "secure image to_open_graph" =
  secure_image_cover |> Media.to_open_graph |> dump_data Meta.to_data_list;
  [%expect
    {|
    [{"name": "og:image", "content": "http://example.com/image.png"},
    {"name": "og:image:secure_url", "content":
     "https://cdn.example.com/image.png"}]
    |}]
;;

let%expect_test "from_data image" =
  let open Yocaml.Data in
  record
    [ "kind", string "image"; "url", string "https://example.com/image.png" ]
  |> Media.from_data
  |> dump_validation Media.to_data;
  [%expect
    {|
    [V] {"kind": "image", "url":
         {"kind": "external", "target": "https://example.com/image.png", "url":
          {"target": "https://example.com/image.png", "scheme": "https", "host":
           "example.com", "port": null, "path": "/image.png", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false}},
        "secure_url": null, "mime_type": null, "width": null, "height": null,
        "alt": null}
    |}]
;;

let%expect_test "from_data url" =
  let open Yocaml.Data in
  string "https://example.com/image.png"
  |> Media.from_data
  |> dump_validation Media.to_data;
  [%expect
    {|
    [V] {"kind": "image", "url":
         {"kind": "external", "target": "https://example.com/image.png", "url":
          {"target": "https://example.com/image.png", "scheme": "https", "host":
           "example.com", "port": null, "path": "/image.png", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false}},
        "secure_url": null, "mime_type": null, "width": null, "height": null,
        "alt": null}
    |}]
;;

let%expect_test "from_data kind normalization" =
  let open Yocaml.Data in
  record
    [ "kind", string "  VIDEO  "
    ; "url", string "https://example.com/video.mp4"
    ]
  |> Media.from_data
  |> dump_validation Media.to_data;
  [%expect
    {|
    [V] {"kind": "video", "url":
         {"kind": "external", "target": "https://example.com/video.mp4", "url":
          {"target": "https://example.com/video.mp4", "scheme": "https", "host":
           "example.com", "port": null, "path": "/video.mp4", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false}},
        "secure_url": null, "mime_type": null, "width": null, "height": null,
        "alt": null}
    |}]
;;

let%expect_test "from_data mime_type" =
  let open Yocaml.Data in
  record
    [ "kind", string "video"
    ; "url", string "https://example.com/video.mp4"
    ; "mime_type", string "video/mp4"
    ]
  |> Media.from_data
  |> dump_validation Media.to_data;
  [%expect
    {|
    [V] {"kind": "video", "url":
         {"kind": "external", "target": "https://example.com/video.mp4", "url":
          {"target": "https://example.com/video.mp4", "scheme": "https", "host":
           "example.com", "port": null, "path": "/video.mp4", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false}},
        "secure_url": null, "mime_type": "video/mp4", "width": null, "height":
         null, "alt": null}
    |}]
;;

let%expect_test "from_data mime_type alias" =
  let open Yocaml.Data in
  record
    [ "kind", string "video"
    ; "url", string "https://example.com/video.mp4"
    ; "type", string "video/mp4"
    ]
  |> Media.from_data
  |> dump_validation Media.to_data;
  [%expect
    {|
    [V] {"kind": "video", "url":
         {"kind": "external", "target": "https://example.com/video.mp4", "url":
          {"target": "https://example.com/video.mp4", "scheme": "https", "host":
           "example.com", "port": null, "path": "/video.mp4", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false}},
        "secure_url": null, "mime_type": "video/mp4", "width": null, "height":
         null, "alt": null}
    |}]
;;

let%expect_test "from_data dimensions" =
  let open Yocaml.Data in
  record
    [ "kind", string "image"
    ; "url", string "https://example.com/cover.png"
    ; "width", int 1200
    ; "height", int 630
    ]
  |> Media.from_data
  |> dump_validation Media.to_data;
  [%expect
    {|
    [V] {"kind": "image", "url":
         {"kind": "external", "target": "https://example.com/cover.png", "url":
          {"target": "https://example.com/cover.png", "scheme": "https", "host":
           "example.com", "port": null, "path": "/cover.png", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false}},
        "secure_url": null, "mime_type": null, "width": 1200, "height": 630,
        "alt": null}
    |}]
;;

let%expect_test "from_data dimensions alias" =
  let open Yocaml.Data in
  record
    [ "kind", string "image"
    ; "url", string "https://example.com/cover.png"
    ; "w", int 1200
    ; "h", int 630
    ]
  |> Media.from_data
  |> dump_validation Media.to_data;
  [%expect
    {|
    [V] {"kind": "image", "url":
         {"kind": "external", "target": "https://example.com/cover.png", "url":
          {"target": "https://example.com/cover.png", "scheme": "https", "host":
           "example.com", "port": null, "path": "/cover.png", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false}},
        "secure_url": null, "mime_type": null, "width": 1200, "height": 630,
        "alt": null}
    |}]
;;

let%expect_test "from_data width only" =
  let open Yocaml.Data in
  record
    [ "kind", string "image"
    ; "url", string "https://example.com/cover.png"
    ; "width", int 1200
    ]
  |> Media.from_data
  |> dump_validation Media.to_data;
  [%expect
    {|
    [V] {"kind": "image", "url":
         {"kind": "external", "target": "https://example.com/cover.png", "url":
          {"target": "https://example.com/cover.png", "scheme": "https", "host":
           "example.com", "port": null, "path": "/cover.png", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false}},
        "secure_url": null, "mime_type": null, "width": null, "height": null,
        "alt": null}
    |}]
;;

let%expect_test "from_data secure_url" =
  let open Yocaml.Data in
  record
    [ "kind", string "image"
    ; "url", string "http://example.com/image.png"
    ; "secure_url", string "https://cdn.example.com/image.png"
    ]
  |> Media.from_data
  |> dump_validation Media.to_data;
  [%expect
    {|
    [V] {"kind": "image", "url":
         {"kind": "external", "target": "http://example.com/image.png", "url":
          {"target": "http://example.com/image.png", "scheme": "http", "host":
           "example.com", "port": null, "path": "/image.png", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false}},
        "secure_url":
         {"target": "https://cdn.example.com/image.png", "scheme": "https",
         "host": "cdn.example.com", "port": null, "path": "/image.png",
         "has_port": false, "query_params":
          {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
          "elements": []},
         "query_string": null, "has_query_string": false},
        "mime_type": null, "width": null, "height": null, "alt": null}
    |}]
;;

let%expect_test "from_data alt" =
  let open Yocaml.Data in
  record
    [ "kind", string "image"
    ; "url", string "https://example.com/image.png"
    ; "alt", string "Example image"
    ]
  |> Media.from_data
  |> dump_validation Media.to_data;
  [%expect
    {|
    [V] {"kind": "image", "url":
         {"kind": "external", "target": "https://example.com/image.png", "url":
          {"target": "https://example.com/image.png", "scheme": "https", "host":
           "example.com", "port": null, "path": "/image.png", "has_port": false,
          "query_params":
           {"kind": "map", "length": 0, "is_empty": true, "is_not_empty": false,
           "elements": []},
          "query_string": null, "has_query_string": false}},
        "secure_url": null, "mime_type": null, "width": null, "height": null,
        "alt": "Example image"}
    |}]
;;

let%expect_test "from_data alt rejects blank" =
  let open Yocaml.Data in
  record
    [ "kind", string "image"
    ; "url", string "https://example.com/image.png"
    ; "alt", string ""
    ]
  |> Media.from_data
  |> dump_validation Media.to_data;
  [%expect
    {|
    [X] --- Oh dear, an error has occurred ---
    Validation error:
    Entity: `test`


    Invalid record:
      Errors (1):
      1) Invalid field `alt`:
           Message:
             Message: should not be blank
             Given: ``

      Given record:
        kind = `"image"`
        url = `"https://example.com/image.png"`
        alt = `""`---
    The backtrace is not available because the function is called (according to the [in_exception_handler] parameter) outside an exception handler. This makes the trace unspecified.
    |}]
;;
