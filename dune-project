(lang dune 3.20)
(name yocaml-codex)
(version dev)
(generate_opam_files)

(source (github yocaml/yocaml-codex))
(license GPL-3.0-or-later)
 
(authors
  "gr-im <grimfw@gmail.com>"
  "The XHTMLBoy <xhtmlboi@gmail.com>"
  "xvw <xaviervdw@gmail.com>"
  "msp <spanwmick@gmail.com>")
 
(maintainers
  "gr-im <grimfw@gmail.com>"
  "The XHTMLBoy <xhtmlboi@gmail.com>"
  "xvw <xaviervdw@gmail.com>"
  "msp <spanwmick@gmail.com>")

(package
 (name yocaml-codex)
 (synopsis "A YOCaml Standard Library")
 (description
   "A set of data models that can be used with YOCaml to build rich pages")
 (depends
  (ocaml (>= 5.3.0))
   yocaml
   yocaml_syndication

  ;; test setup
  (ppx_expect :with-test)
   
  ;; dev setup
  (utop :with-dev-setup)
  (ocamlformat (and :with-dev-setup (= 0.28.1)))
  (ocp-indent :with-dev-setup)
  (merlin :with-dev-setup)
  (ocaml-lsp-server :with-dev-setup)))
