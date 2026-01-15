let dump f x = x |> f |> print_endline
let dump_string = dump Fun.id

let dump_list f list =
  list
  |> List.map f
  |> Format.asprintf
       "%a"
       (Format.pp_print_list
          ~pp_sep:(fun ppf () -> Format.fprintf ppf ";\n")
          (fun ppf s -> Format.fprintf ppf "`%s`" s))
  |> dump_string
;;

let dump_opt_list f =
  dump_list (function
    | None -> "None"
    | Some x -> "Some(" ^ f x ^ ")")
;;

let dump_opt f = function
  | None -> ()
  | Some x -> dump f x
;;

let dump_data_list f =
  dump_list (fun x -> x |> f |> Format.asprintf "%a" Yocaml.Data.pp)
;;

let dump_data f data =
  data |> f |> Format.asprintf "%a" Yocaml.Data.pp |> print_endline
;;

let dump_validation to_data = function
  | Ok value ->
    value
    |> to_data
    |> Format.asprintf "[V]\t%a" Yocaml.Data.pp
    |> print_endline
  | Error error ->
    let open Yocaml in
    let exn =
      Eff.Provider_error (Required.Validation_error { entity = "test"; error })
    in
    exn
    |> Format.asprintf
         "[X]\t%a"
         (Diagnostic.exception_to_diagnostic
            ?custom_error:None
            ~in_exception_handler:false)
    |> print_endline
;;

let not_blank = Yocaml.Data.Validation.(string & String.not_blank)

module Person = struct
  type t =
    { display_name : string
    ; first_name : string option
    ; last_name : string option
    }

  let make ?first_name ?last_name display_name =
    { display_name; first_name; last_name }
  ;;

  let compare { display_name; _ } b = String.compare display_name b.display_name

  let to_data { display_name; first_name; last_name } =
    let open Yocaml.Data in
    record
      [ "display_name", string display_name
      ; "first_name", option string first_name
      ; "last_name", option string last_name
      ]
  ;;

  let from_data =
    let open Yocaml.Data.Validation in
    (string
     $ fun display_name -> { display_name; last_name = None; first_name = None }
    )
    / record (fun f ->
      let+ display_name = required f "display_name" not_blank
      and+ first_name = optional f "first_name" not_blank
      and+ last_name = optional f "last_name" not_blank in
      { display_name; first_name; last_name })
  ;;
end
