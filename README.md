# YOCaml Codex

> [YOCaml](https://github.com/xhtmlboi/yocaml) is a _framework_ for
> building static site generators. By reading the
> [tutorial](https://yocaml.github.io/tutorial/), one quickly realizes
> that it is **very flexible**, allowing users a _great deal of
> freedom_ to do whatever they want. **YOCaml Codex** is a _standard
> library_ that provides prebuilt (_recurring_) models to simplify
> site creation.

By repeatedly building sites using
[YOCaml](https://github.com/xhtmlboi/yocaml), _we_ (the maintainers)
realized that certain parts of the data model were being copied from
project to project (such as `Url`, `Repository`, etc.). Rather than
providing these directly in YOCaml (as an extended version of
`Archetype`), we decided to keep the core dependencies as small as
possible and to create a dedicated library that would provide all
these reusable tools.

## Library organisation

The library is called `yocaml-codex`, and all of its internal
libraries are prefixed with `Codex_`. It exposes several
_sub-libraries_ :

- `yocaml-codex.atoms`, `Codex_atoms`, which describes the set of
  **primitive types** one might want to use (such as `url`)

- `yocaml-codex.ontology`, `Codex_ontology`, which describes complete
  data models (such as `repository`)

## Local development environment

To work, we assume that a version greater than or equal to `2.2.0~beta1` of
[OPAM](https://opam.ocaml.org) is installed on your machine ([Install
OPAM](https://opam.ocaml.org/doc/Install.html), [upgrade to version
`2.2.0~xxxx`](https://opam.ocaml.org/blog/opam-2-2-0-beta2/#Try-it)).

> [!TIP]  
> We're relying on version `2.2.x` to support the `dev-setup` flag, which allows
> development dependencies to be packaged, making it very practical to install
> locally all the elements needed to create a pleasant development environment.

When you have a suitable version of OPAM, you can run the following command to
build a [local switch](https://opam.ocaml.org/blog/opam-local-switches/) to
create a sandboxed environment (with a good version of OCaml, and all the
dependencies installed locally).

```shell
opam update
opam switch create . --deps-only --with-dev-setup --with-test --with-doc -y
eval $(opam env)
```
