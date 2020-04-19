# Programming Language

## Lecture 3: First-Class Functions & Function Closures

### 1. Intro to First-Class Functions
- *Function Programming* means...
	- Avoiding mutations at most cases
	- Using functions as values (this section)
	- Recursion, laziness, mathematical style...
- First-Class Functions
	- Pass them as arguments or result of other functions
	- The *other functions* are called *higher-order function*
- Function Clousures
	- Functions can use bindings from *outside* the function definition (in scope where the function is defined)
	- Which makes first-class function powerful

### 2. Functions as Arguments
- Function Closure
- Polymorphic Types and Closure
	- Type is *inferred* based on how arguments are used 
	- Higher-order functions are often polymorphic, i.e. have types with type variables
		- Different usages of polymorphic function initialize its type differently
		- There are also polymorphic first-class functions, or non-polymorphic higher-order functions
	- Types of Functions
		- e.g. `fun n_times(f, n, x)`
		- Type: `('a -> 'a) * int * 'a -> 'a`

### 3. Anonymous Functions
- A function binding is not an expression => a more clean way of defining helper funciton is needed
	- `fn` is not a binding, but an expression for anonymous function
	- The most common use: passing as argument
	- Cannot used as a recursive function

### 4. Unnecessary Function Wrapping
- An inferior style of using anonymous function
	- e.g. `fn y => tl y` should be written as `tl`

### 5. Map and Filter
- *Map* Function
	- "Higer-order function hall-of-frame"
	- Type: `('a -> 'b) * 'a list -> 'b list`
- *Filter* Function
	- Also a "hall-of-frame"
	- Type: `('a -> bool') * 'a list -> 'a list`

### 6. Generalizing Prior Topics
- First-Class Functions
	- Functions are first-class values

### 7. Lexical Scope
- First-class functions that can be passed around: in what scope?
	- *Where the function was defined* (not where it was called)
	- This semantics is called **lexical scope**

- The Semantics of Functions
	- A function value has two parts:
		- The **code**
		- The **environment** that was current when the function was *defined*
	- The pair composed of these two parts is called **function closure**
	- A function body is evaluated in the environment where the function was defined, and a *function call* triggers the evaluation

- Lexical Scope for Higher-Order Functions

- Lexical Scope vs. Dynamic Scope
	- Why Lexical?
		- 1. The function meaning does not depend on variable names used
		- 2. function should be type-checked and reasoned when defined
		- 3. Closure can easily store the data
	- Sometimes dynamic scope is more useful, e.g. exception handling

### 8. Closures and Recomputation
- A function body is evaluated *every time* the function is called
	- We can avoid repeating computaions by using closures

### 9. Fold Function and More Closures
- Synonym for *Reduce*
- Iterators Made Better
	- Lexical scope and closures make `map`, `filter` and `fold` very powerful for iterators
	- Function passed in can use any "private" data in its environment, and the iterator is *igonorant* to the data
