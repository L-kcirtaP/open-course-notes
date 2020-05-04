# Programming Language

## Lecture 4: Remaining Topics in ML

### 1. Type Inference
- Type-Checking
	- Statically Typed
		- The type of every binding is determined at compile time
		- ML is *statically* typed and *implicitly* typed (rarely need to write down types)
	- Dynamically Typed

- Type Inference: give every binding/expression a type such that type-checking succeeds

- Type Inference in ML
	- Determine types of bindings *in order*
		- For `val` or `fun`: analyze definitions for all constraints (e.g. `x > 0` implies `x` has type `int`)
		- Afterwards, use type variable (e.g. `'a`) for unconstrained variables
	- Regarding **polymorphism**: it can refer types with type variables
		- Languages can have type inference without type variables
		- Languages can have type variables without type inference (you have to write down all type variables)

- Value Restriction
	- A variable-binding can have a polymorphic type *only if* the expression is a variable or value
		- Otherwise, get a warning: type vars not generalized because of
   value restriction are instantiated to dummy types
    - Downside: causes unnecessary restriction
    - Despite value restriction, polymorphism still makes ML type inference elegant and easy to do

### 2. Mutual Recursion
- `f` calls `g` and `g` calls `f`
- Problem: bindings-in-order rules
	- Fix #1: new language construct
	- Fix #2: higher-order function

- New Language Features: `and` Keyword
	- Used to define mutually recursive structures
	- `fun f1 p1 = e1; and f2 p2 = e2; and f3 p3 = e3`
	- `datatype t1 = ...; and t2 = ...; and t3 = ...`
	- They will be type-checked together
	- Application: Implement State-Machine
		- Each *state of computation* is a function. *State transition* is "call another function" with "rest of input" => finite-state machine
- Or: Solved by Higher-Order Function
	- Can have the "later" function pass itself to the "earlier" one

### 3. Modules for Namespace Management
- Define modules: *structure*
	- `structure MyModule = struct bindings end`
	- Inside the module, can use earlier bindings as usual
	- Outside the module, refer to earlier modules' bindings via `ModuleName.bindingName`, e.g. `List.map`
	- `open ModuleName`

### 4. Signatures and Hiding Things
- Signatures
	- A type for module
		- What bindings does it have and what are their types
	- Can define a signature and ascribe it to modules
	- Define signatures
		- `signature SIGNAME = sig types-for-bindings end`
	- Ascribe a signature to a module
		- `structure MyModule :> SIGNAME = struct bindings end`
	- Real values of signature: **HIDE** bindings and type definitions
		- Any binding not defined in the signature *cannot* be used outside the module
		- Library *spec* and *invariants*
			- e.g. for the `Rational1` module
				- Properties (*visible* guarantees for library clients): disallow denominator of 0, return strings in reduced form, no infinite loops or exceptions...
				- Invariants (implementation details, *invisible* to clients): all denominators are greater than 0, all `rational` values returned from functions are reduced
			- Good signatures ensure the specs and invariants cannot be violated by clients
				- e.g. by revealing the datatype definition, we make client able to violate our invariants by directly creating values, like `Rational1.Frac(1, 0)`
			- An ADT must hide the concrete type definition
	- A summary of signature
		- Deny bindings exist
		- Make type abstract

### 5. Signature Matching
- The type-check for the mudule given a signature
	- A module `structure Foo :> BAR` is allowed if:
		- Every non-abstract type in `BAR` is provided in `Foo` as specified
		- Every abstract type in `BAR` is provided in `Foo` in some way, e.g. a datatype binding or a type synonym
		- Every val-binding in `BAR` is provided in `Foo`
		- Every exception in `BAR` is provided in `Foo`
		- `Foo` can have more bindings than `BAR`

### 6. An Equivalent Structure
- Key purpose of **abstraction**: allow *different implementations* to be *equivalent*
	- e.g. modules can have signatures `RATIONAL_A`, `RATIONAL_B`, `RATIONAL_C`, but only equivalent under `RATIONAL_B` and `RATIONAL_C`
		- In the code example, modules `structure Rational1` and `structure Rational2` are equivalent under `RATIONAL_B` and `RATIONAL_C`
	- By exposing *less* of the module, it is more likely one module implementation can be replaced by another because under a more restrictive signature, more implementation details are hidden, thus disallowing clients from exploiting the differences between the two modules.


### 7. Another Equivalent Structure
- Given a signature with an abstraction type, a *different structure* can have that signature but implement the abstract type differently 
	- Such structures might and might not be equivalent

- Different Modules Define Different Types
	- Module with the *same* signatures still define *different* types

### 8. Equivalent Functions
- Two functions are equivalent if they have the same **observable behavior**
	- Produce equivalent results
	- Have the same (non-)termination behavior
	- Mutate memory in the same way
	- Do the same input/output
	- Raise the same exceptions
	- etc.

### 9. Standard Equivalences
- Use or not use **syntactic sugar** is always equivalent
- Use or not use **helper function** is always equivalent
- Unnecessary function wrapping

- There are different definitions of equivalence for different jobs
	- PL Equivalence: given same inputs, same outputs and effects
	- Asymptotic Equivalence: ignore constant factors
	- System Equivalence: account for constant overheads and performance tune
