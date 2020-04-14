# Programming Language

- Essential concepts in any programming language
- Use Standard ML, Racket and Ruby languages.
- Big focus on *functional programming*.

## Lecture 1: ML Variable Binding and Expressions

### 1. Variable Binding

- Syntax: how to write something
- Semantics: what that something means
  - Type-checking (before the program runs): extends static environment
  - Evaluation (as program runs): extends dynamic environment

### 2. Expressions

- Syntax: sequence of letters, digits, _, not starting with digit
- Type-checking: look up **type** in current **static** environment
  - fails if not there
- Evaluatin: look ip **value** in current **dynamic** environment

( subexpression (recursive) )

#### Values
- All values are expressions
- Not all expressions are values
- Every value *evaluates to itself* in *zero steps*

### 3. The REPL and Errors
- Errors
  - Syntax, type-checking and evaluation mistakes
  - Error messages might not be helpful

### 4. Shadowing
Add a variable to an environment when before you added it, that variable are already in the environment.

- Expression in variable binding are evaluated "eagerly" before the binding finished
  - Afterawards, the expression producing the value is irrelevant
- There is no way to "assign to" a variable in ML
  - Can only **shadow** it in a later environment

### 5. Function
- Cannot refer to later function bindings
- Recursion

#### Function Formally
- Function Binding
  - Syntax: `fun x0 (x1 : t1, ..., xn : tn) = e`
  - Type-checking
    - Add binding `x0 : (t1 * ... * tn) -> t`
    - Type-check the function body `e` to have type `t` in the **static** environment
  - Evaluation: **A function is a value!** No evaluation yet.
    - Add `x0` to **dynamic** environemnt when binding, so later expressions can call it

- Function Calls
  - Syntax: `e0 (e1, ..., en)`
  - Type-checking
  - Evaluation (3 steps)
    - Under current dynamic environment, evaluates `e0` to decide what function to call. Here `func x0 (x1 : t1, ..., xn : tn) = e`
    - Under current dynamic environment, evaluates arguments `e1, ...` to values `v1, ...`
    - Result is the evaluation of `e` in an *environment* extended to map `x1` to `v1`, ..., `xn` to `vn`
      - the environment is actually the environment where the fuction was defined

### 6. Pair and Other Tuples
- Tuples: fixed number of pieces that may have different types
- Lists: dynamic number of items that all have the same types
  
#### Pairs (2-tuples)
- Build:
  - Syntax: `(e1, e2)`
  - Type-checking: if `e1` has type `ta` and `e2` has type `tb`, then the pair expression has type `ta * tb`, a new kind of type
  - Evaluation: result `(v1, v2)`

- Access:
  - Syntax: `#1 e` and `#2 e`
  - Type-checking
  - Evaluation: evaluate `e` to a pair of values and return first or second piece

#### Tuples
A generalization of pairs
- Nesting: tuples can be nested however you want

### 6. Lists
- A list of values is a value, `[v1, v2, ..., vn]`
- If `e1` evaluates to `v` and `e2` evaluates to a list `[v1, ..., vn]`, then `e1::e2` evaluates to `[v, v1, ..., vn]`
  - `::` pronounced "cons"

- Access:
  - `null e` evaluates to `true` if and only if `e` evaluates to `[]`
  - `hd e` and `tl e` evaluate to `v1` (an int) and `[v2, ..., vn]` (an int list) respectively.
    - Raise exception if `null e`

- Type-checking of lists
  - For any type `t`, the type `t list` describes the list
  - `[]`: 'a (alpha) list, can be any list type
  - For `e1::e2` to type-check, we need `e1` has type `t` and `e2` has type `t list`

### 7. List Functions
~~This guy never use `for` loop~~
- **Recursion** is the only way to get to all the element for functions over lists

### 8. Let Expressions
- Local bindings
  - Use nested function binding to gain efficiency

#### Let-expressions
- Syntax: `let b1 b2 ... bn in e end`
  - Each `bi` is any binding and `e` is any expression
- Type-checking: Type-check each `bi` and `e` in a static environment that includes the previous bindings
- Evaluation: Result of whole let-expression is the result of `e`

#### What's new
- Recall *shadow*: top-level binding in the rest of the program
- Scope
  - Binding is in the environment only in **later** bindings and body of the let-expression

### 9. Nested Funcitons
- Any binding
  - Functions can be defiend anywhere (in `let` expression)
- Nested functions: good style
  - To define helper functions inside the funcitons they help if they are
    - Unlikely to be useful elsewhere
    - Likely to be misused
    - Likely to be removed later

### 10. Let Expression and Efficiency
- Avoid repeated recursion
  - **Saving** recursive results in **local bindings** is essential

### 11. Options
- `t option`: a type for any type `t`
- Building
  - `NONE` has type `'a option`
  - `SOME e` has type `t option` if `e` has type `t`
- Accessing:
  - `isSome` has type `'a option -> bool`
  - `valOf` has type `'a option -> 'a` (exception if given NONE)

### 12. Booleans and Comparison Oprations
- `andalso`, `orelse`, `not` operator

### 13. Benifit of Immutable Data
- Non-Feature: something that ML doesn't have
  - a mojor aspect to fp: not able to assign to (mutate) variables or parts of tuples/lists
  - we don't need to care about aliasing and object identity, because it can't tell
  - a bad example in Java

## The Piece of Learning a Language
1. Syntax
2. Semantics (type-checking and evaluation rules)
3. Idioms: typical patterns to use language features
4. Libraries: facilities that the language provide as standard
5. Tools: REPL, debugger, formatter, etc.
