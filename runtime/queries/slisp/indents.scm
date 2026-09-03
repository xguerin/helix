;; Indentation, after slfmt's layout.
;;
;; slfmt starts every continuation line at a node's column, never at an offset
;; from a paren: a broken list continues under its head, one column past its
;; paren, a plain call packing its arguments from the head's line wraps under
;; the first of them, a let aligns its bindings under the first one, and only
;; a top-level form, which nothing encloses, indents its body two columns in.
;;
;; Helix aligns to a node's start column exactly and lets the innermost
;; alignment win, dropping every indent level under it, so each list below
;; carries exactly one alignment of its own and a line lands where the
;; innermost list containing it says, however the lists nest and whatever
;; sigil or padded dot sits in front of them. A query names one parent kind
;; per pattern, so each rule repeats over the four list kinds: a call, a
;; template, and the two use groups.

;; Top-level forms: the body two columns in.
[
  (external_definition)
  (function_definition)
  (macro_definition)
  (use_module)
  (val_definition)
] @indent

;; Special forms: under the keyword.
(inout_type "inout" @anchor) @align
(lambda_stmt "\\" @anchor) @align
(let_stmt "let" @anchor) @align
(out_type "out" @anchor) @align
(special_stmt ["if" "prog"] @anchor) @align
(struct_type "struct" @anchor) @align

;; A list headed by anything but a name: under its head.
((apply_stmt . (_) @anchor) @align
  (#not-kind-eq? @anchor "symbol")
  (#not-kind-eq? @anchor "gensym"))
((quasi_list . (_) @anchor) @align
  (#not-kind-eq? @anchor "symbol")
  (#not-kind-eq? @anchor "gensym"))

;; A list headed by a name standing alone on its line: under the head.
((apply_stmt . [(symbol) (gensym)] @anchor . (_) @next) @align
  (#not-same-line? @anchor @next))
((quasi_list . [(symbol) (gensym)] @anchor . (_) @next) @align
  (#not-same-line? @anchor @next))
((use_item_group . (symbol) @anchor . (_) @next) @align
  (#not-same-line? @anchor @next))
((use_module_select . (symbol) @anchor . (_) @next) @align
  (#not-same-line? @anchor @next))

;; A list holding its head alone, the one a new line is typed into: under
;; the head.
(apply_stmt . [(symbol) (gensym)] @anchor .) @align
(quasi_list . [(symbol) (gensym)] @anchor .) @align
(use_item_group . (symbol) @anchor .) @align
(use_module_select . (symbol) @anchor .) @align

;; A special form written as a call or a template, keeping its test, subject,
;; name or parameters on the head's line: under the head.
((apply_stmt . (symbol) @anchor . (_) @next) @align
  (#same-line? @anchor @next)
  (#any-of? @anchor
    "\\" "cond" "def" "ext" "if" "if-match" "let" "let*" "mac" "match" "task"
    "unless" "unless-match" "val" "when" "when-match"))
((quasi_list . (symbol) @anchor . (_) @next) @align
  (#same-line? @anchor @next)
  (#any-of? @anchor
    "\\" "cond" "def" "ext" "if" "if-match" "let" "let*" "mac" "match" "task"
    "unless" "unless-match" "val" "when" "when-match"))

;; A plain call or a use group packed from the head's line: under the first
;; argument.
((apply_stmt . [(symbol) (gensym)] @head . (_) @anchor) @align
  (#same-line? @head @anchor)
  (#not-any-of? @head
    "\\" "cond" "def" "ext" "if" "if-match" "let" "let*" "mac" "match" "task"
    "unless" "unless-match" "val" "when" "when-match"))
((quasi_list . [(symbol) (gensym)] @head . (_) @anchor) @align
  (#same-line? @head @anchor)
  (#not-any-of? @head
    "\\" "cond" "def" "ext" "if" "if-match" "let" "let*" "mac" "match" "task"
    "unless" "unless-match" "val" "when" "when-match"))
((use_item_group . (symbol) @head . (_) @anchor) @align
  (#same-line? @head @anchor))
((use_module_select . (symbol) @head . (_) @anchor) @align
  (#same-line? @head @anchor))

;; Let bindings: each under the first binding's open paren.
(let_bindings "(" . "(" @anchor) @align

;; A foreign signature: each (name . type) under the first.
(signature "(" . "(" @anchor) @align

;; Parameters and deconstructions: the rest under the first name.
(parameters . (_) @anchor) @align
(decons_list . (_) @anchor) @align
