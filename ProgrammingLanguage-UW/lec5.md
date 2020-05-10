# Programming Language (Part B)

- Part B Outline
		- "re-do" of Part A content in a dynamically type language, Racket
		- Deleying Evaluation
		- Macros
		- Datatype-Programming in Racket
		- Implementing Programming Languages
		- Static vs. Dynamic Typing

## Lecture 5: Introduction to Racket

### 1. Introduction
- Racket
	- Functional programming like ML, but without pattern-matching, static type system, etc.
	- Similar to *Scheme*

### 2. Racket Lists
- Syntax
	- Empty list: `null`
	- Constructor: `cons`
	- Access head of list: `car`
	- Access tail of list: `cdr`
	- Check for empty: `null?`
	- `(list e1 ... en)` for building lists

### 3. Syntax and Parentheses
- A `term` in Racket is either
	- An *atom*, e.g. `#t`, `#f`, `34`, `"hi"`. `x`...
	- A *special form*, e.g. `define`, `lambda`, `if`
		- Macros will let us define our own form
	- A *sequence* of terms in parens: `(t1 t2 ... tn)`
		- if `t1` is a special form, semantics of sequence is special; else a **function call**

- Why Parentheses?
	- By parenthesizing everything, the program text is converted into a tree representing the program
		- Atoms are leaves
		- Sequences are nodes with elements as children

- Parentheses Matter
	- Every parenthesis has its meaning
	- `(e)` means calling `e` with zero arguments

### 4. Dynamic Typing
- No type checker
	- Possible runtime errors

### 5. Cond
- 
