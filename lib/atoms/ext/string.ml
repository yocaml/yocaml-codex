module S = Stdlib.String
module B = Stdlib.Buffer

let from_char = S.make 1

let char_at i str =
  try Some (S.get str i) with
  | Invalid_argument _ -> None
;;

let from_filtered_list f l =
  let buf = B.create 256 in
  let () =
    Stdlib.List.iter
      (fun x ->
         match f x with
         | None -> ()
         | Some x -> B.add_string buf x)
      l
  in
  B.contents buf
;;

let from_list f = from_filtered_list (fun x -> Some (f x))
let from_char_list = from_list from_char
let to_list f str = S.fold_right (fun c acc -> f c :: acc) str []
let to_char_list = to_list Fun.id

let concat_with ~sep f l =
  let buf = B.create 256 in
  let () =
    Stdlib.List.iteri
      (fun i x ->
         let sep = if Stdlib.Int.equal i 0 then "" else sep in
         B.add_string buf sep;
         B.add_string buf (f x))
      l
  in
  B.contents buf
;;

let ltrim_when pred str =
  let len = S.length str in
  let i = ref 0 in
  while !i < len && pred (S.unsafe_get str !i) do
    incr i
  done;
  if !i < len then S.sub str !i (len - !i) else ""
;;

let rtrim_when pred str =
  let len = S.length str in
  let j = ref (len - 1) in
  while !j >= 0 && pred (S.unsafe_get str !j) do
    decr j
  done;
  if !j >= 0 then S.sub str 0 (!j + 1) else ""
;;

let trim_when pred str =
  let len = S.length str in
  let i = ref 0 in
  while !i < len && pred (S.unsafe_get str !i) do
    incr i
  done;
  let j = ref (len - 1) in
  while !j >= !i && pred (S.unsafe_get str !j) do
    decr j
  done;
  if !j >= !i then S.sub str !i (!j - !i + 1) else ""
;;

let remove_leading_char_when pred string =
  match
    try Some (S.get string 0) with
    | Invalid_argument _ -> None
  with
  | Some c ->
    if pred c
    then (
      let len = S.length string in
      S.sub string 1 (len - 1))
    else string
  | None -> string
;;

let remove_leading_arobase = remove_leading_char_when (Char.equal '@')
let remove_leading_dot = remove_leading_char_when (Char.equal '.')
let remove_leading_hash = remove_leading_char_when (Char.equal '#')
