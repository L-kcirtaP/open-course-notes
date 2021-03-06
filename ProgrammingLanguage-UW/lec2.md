# Programming Language

## Lecture 2: Ways to New Types

### 1. Build Compound Types
- 3 most important type building-blocks in *any* language
	- "each of": a `t` value contains values of each of `t1 t2 ... tn`
	- "one of": a `t` value contains values of one of `t1 t2 ... tn`
	- "self reference": a `t` value can refer to other `t` values
	- For example:
		- Tuples build each-of types
		- Options build one-of types
		- Lists uses all three building blocks
			- `int list` contains an `int` and another `int list` or it contains no data

### 2. Records
- A new way of making **each-of type**
	- Build: `{f1 = e1, ..., fn = en}`
	- Access field: `#fi record`
- Access by position vs. by name:
	- In function call, it is a hybrid:
	- caller passes arguments by position
	- callee accesses arguments by name

### 3. Tuples as Syntactic Sugar
- Tuple is just a different way of writing record
- New perspective:
	- `(e1, ..., en)` is another way of writing `{1=e1,..., n=en}`
	- `t1 * ... * tn` is another way of writing `{1:t1,..., n:tn}`
- **Syntactic Sugar**
	- can describe the semantisc entirely by the corresponding record syntax
	- they simplify understanding and implementing the language
	- another example: `andalso` vs. `if then else`

### 4. Datatype Bindings
- A way to make **one-of types**
	- `datatype` binding

`datatype t = C1 of t1 | C2 of t2 | ... | Cn of tn`

- Build
	- Add a new type `mytype` to the environment
	- Add constructors to the environment: `TwoInts, Str, Pizza`
		- A constructor is a function that makes values of the new type
		- Tag & Value
			- with type `t`, we construct a tag and a underneath value
			- omit `of t`, then constructors are just tags without data
	- Any value of type `mytype` is made from *one of* the constructors, it contains
		- a "tag" for "which constructor" (e.g. `TwoInts`)
		- the corresponding data (e.g. `(3,2)`)

- Access: two aspects
	- **Check** what variant it is: what constructor made it
	- **Extract** the data (if that variant has any)
	- ML did "something better" for accessing than other languages

### 5. Case Expressions
- ML combines the two aspects of accessing an one-of value with a `case` expression and *pattern matching*
- A multi-branch conditional to pick branch based on variant
	- Extracts data and binds to variables local to that branch
	- Type-checking: all branches must have same type
	- Evaluation: get the data then evaluate in the expression (similar to `let`)

- Patterns
	- In general the syntax:
		- `case e0 of p1 => e1 | p2 => e2 | ... | pn => en`
	- Each *pattern* is a constructor name followed by the right number of variables
	- We don't evaluate patterns (they are not expressions), we only see if the result of `e0` matches them

- Why it's better?
	- You cannot forget/duplicate a case (the compiler will check)
	- You won't forget to test the variant correctly
	- Pattern-matching can be generalized and made more powerful!

### 6. Useful Datatypes
- Enumerations
- Alternate ways of identifying real-world things
- Expression Trees
	- Function over recursive datatypes are usually recursive

### 7. Type Synonyms
- *datatype* binding introduces a new type name
- *type synonym* is a new kind of binding, just create another name for an existing type


### 8. Lists and Options are Datatypes
- using `datatype` instead of `isSOme`, `ValOf`, `null`, `hd`, `tl` is usually better

### 9. Polymorphic Datatypes
- `list` and `option` are not types, instead, they are **polymophic type constructors**
	- e.g. `int list`, `int list list` are types, but `list` is not

- Define polymorphic datatypes
	- Syntax: put one or more type variables before datatype name

### 10. Pattern-Matching for Each-Of Types: The Truth About Function Arguments
- Deep truths:
	- Every value-binding and function-binding uses pattern-matching
	- Every function in ML takes exactly one argument
- So far, we have used pattern-matching for one-of types
	- Pattern matching also works for records and tuples:
	- The pattern `(x1,..., xn)` matches the tuple value `(v1,...,vn)`
	- The pattern `{f1=x1,..., fn=xn}` matches the record value `{f1=v1,...,fn=vn}`

- Val-Binding Pattern
	- `val p = e`
	- A val-binding can use a pattern (with exactly one branch), not just a variable => variable is just one kind pattern
	- Do not put a constructor pattern in val-binding (because it's each-of type)
		- tests for the only one variant and raises an RunTime exception if there is a different one

- Function-Argument Patterns
	- A function argument can also be a pattern
		- Match against the argument in a function call
		- `fun f p = e`
	- Don't need to write down type explicitly
- How can the compiler tell if the function `sum_triple` takes a triple or three int as its arguments?
	- Actually they are the SAME
	- BIG TRUTH: EVERY FUNCTION TAKES EXACTLY ONE ARGUMENT

### 11. A Little Type Inference
- Type checker tends to infer the types to be **more general** and reusable
	- Unexpected Polymorphism: some items in the pattern are not used, i.e. not inferred type -> alpha type

### 12. Polymorphic and Equality Types
- Equality types
	- type variables with a second "quote", e.g. `'a list * ''a -> bool`
	- You can only use the `''a` type which you can use the `=` operator on
		- `=` operator  does not work on function types, `real`, ...

### 13. Nested Pattern Matchings
- Style
	- Nested patterns lead to elegant and concise code

- The Full Definition of Pattern-Matching
	 - Takes a pattern `p` and a value `v` and decides
	 	- (1) does it match
	 	- (2) if so, what variable bindings are introduced

### 14. Exceptions
- Exception can carry data
	- e.g. `exception MyException of int * int`
- Handle Exceptions
	- `e1 handle ex => e2`

### 15. Recursion
- The idea of *tail recursion*
	- Improve the efficiency of recursion
	- Achieve it by using an accumulator
- Tail Recursion Optimization
	- It's unnecessary to keep a stack-frame just so it can get callee's result and *return it without any further evaluation*
	- Compiler recognizes the *tail calls* and treats them differently (optimizes)
		- Pop the caller *before* the call, allowing callee to **reuse** the same stack space => as efficient as a loop

- Accumualtors: How to Write Tail Recursive Functions
	- Create a helper funciton that takes an *accumulator*
	- Old base case becomes initial accumulator
	- New base case becomes final accumulator

- Example: function `rev` to reverse a list
	- Non-tail recursive `rev` time complexity: quadratic, because `@` (append) operation traverse the list every time
	- Tail recursive `rev`: linear time
	- In this case, tail version is much better => beware list-append!

- Perspectives of *tail recursion*
	- Cases where tail recursion is not constant space
		- obvious example: functions that process trees
	- Mostly, the natural recursion is the way to go
		- Clean and concise code is also important!
	- What makes a tail-call?
		- "nothing left for caller to do": the result of function is the immediate result for the enclosing function body
	- Precise Definition
		- A *tail call* is a function call in *tail function*
		- Tail position is a position where there is nothing more to do after it
			- If an expression is not in tail position, then no sub-expressions are
