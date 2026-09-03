;; Keywords
[ "if" "prog" ] @keyword

;; Let binding
[ "let" ] @keyword

;; Builtin operators. The list mirrors the reader's operator enum; it comes
;; before the apply-head rules so it wins where earlier patterns take
;; precedence (e.g. Helix).
((symbol) @function.builtin
  (#any-of? @function.builtin
    "apply"
    "+" "-" "*" "/" "%" ">=" ">" "<=" "<"
    "and" "=" "<>" "not" "or"
    "bitand" "bitnot" "bitor" "bitxor"
    "car" "cdr" "conc" "cons"
    "bytes" "chr" "num" "slice" "str" "sym" "unpack"
    "byt?" "chr?" "num?" "lst?" "nil?" "str?" "sym?" "tru?" "wld?"
    "panic"))

;; Apply
(apply_stmt . (symbol) @function)

;; Quasiquote template head (constructed application)
(quasi_list . (symbol) @function)

;; Use module
[ "use" ] @keyword

(use_module_global (quote) . (symbol) @namespace)
(use_module_select (quote) . (symbol) @namespace)
(use_item_group . (symbol) @namespace)

;; Val definition
[ "val" ] @keyword

(val_definition name: (symbol) @constant)

;; External definitions
[ "ext" ] @keyword

(external_definition name: (symbol) @function)
(external_scope library: (symbol) @namespace)
(external_scope symbol: (symbol) @function)
(external_definition signature: (signature (symbol) @variable.parameter (dot) (external_type) @type.builtin))
(external_definition docstring: (string) @string.documentation)
(external_definition return_type: (external_type) @type.builtin)

;; Compound external types: struct fields mirror the parameter idiom, and
;; the out wrapper marks the written-back direction.
(struct_type "struct" @keyword (symbol) @variable.parameter (external_type) @type.builtin)
(out_type "out" @keyword)

;; Function definitions
[ "def" ] @keyword

(function_definition name: (symbol) @function)
(function_definition parameters: (parameters (symbol) @variable.parameter))
(function_definition docstring: (string) @string.documentation)

;; Macro definitions
[ "mac" ] @keyword

(macro_definition name: (symbol) @function)
(macro_definition parameters: (parameters (symbol) @variable.parameter))
(macro_definition docstring: (string) @string.documentation)

;; Lambda 
[ "\\" ] @keyword

(lambda_stmt parameters: (parameters (symbol) @variable.parameter))
(lambda_stmt docstring: (string) @string.documentation)

;; Decons bindings.
(decons_stmt (symbol) @variable.parameter)
(decons_item (symbol) @variable.parameter)

;; Atoms
(char) @constant.character
(comment) @comment
(number) @constant.numeric
(string) @string

;; Punctuation
[ "(" ")" ] @punctuation.bracket

;; Operators
(ampersand) @operator
(colon) @operator
(dot) @operator
(tilde) @operator
(tilde_splice) @operator
(backquote) @operator
(quote) @operator
(unquote) @operator
(unquote_splice) @operator

;; Highlight wildcard as constant
(wildcard) @constant.builtin

;; Highlight nil as constant
[ "nil" ] @constant.builtin

;; Highlight as t as boolean constant
[ "T" ] @constant.builtin.boolean

;; Highlight variable names used in anamorphic macros.
[ "it" ] @variable.builtin

;; Highlight generated symbols (#name) used for macro hygiene.
(gensym) @variable.special
