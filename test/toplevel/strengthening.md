```ocaml
module P = Yocaml.Path.Set
module P' = Codex_atoms.Set.Path
module S = Stdlib.Set.Make (Stdlib.String)
module S' = Codex_atoms.Set.String
```

```ocaml
# let x = 
    let r = P.empty in
    P'.add (Yocaml.Path.rel ["foo"]) r
  ;;
val x : P'.t = <abstr>
```

```ocaml
# let x = 
    let r = S.empty in
    S'.add "foo" r
  ;;
val x : S'.t = <abstr>
```


```ocaml
module P = Yocaml.Path.Map
module P' = Codex_atoms.Map.Path
module S = Stdlib.Map.Make (Stdlib.String)
module S' = Codex_atoms.Map.String
```

```ocaml
# let x = 
    let r = P.empty in
    P'.add (Yocaml.Path.rel ["foo"]) "bar" r
  ;;
val x : string P'.t = <abstr>
```

```ocaml
# let x = 
    let r = S.empty in
    S'.add "foo" "bar" r
  ;;
val x : string S'.t = <abstr>
```
