(* Type Inference *)
(*
	f : T1 -> T2
	x : T1
	y : T3
	z : T4
	Steps:
	T1 = T3 * T4	[type-check for pattern matching]
	T3 = int		[abs has type int -> int]
	T4 = int		[because we added z to an int]
So	T1 = int * int
So	let-expression: int
	body: int
	T2 = int
So 	f : int * int -> int
*)
fun f x = 
	let val (y, z) = x in
		(abs y) + z
	end


(*
	sum : T1 -> T2
	xs : T1
	Steps:
	x: T3
	xs' : T3 list	[pattern matching]
	T1 = T3 list	[by ::]
	T2 = int		[0 might be returned]
	T3 = int
	T1 = int list
	f : int list -> int
*)
fun sum xs = 
	case xs of
		[] => 0
	|	x::xs' => x + (sum xs')

(* polymorphic example *)

(*
	length : T1 -> T2
	xs : T1

	x : T3
	xs' : T3 list
	T1 = T3 list
	T2 = int
	f : 'a list -> int
*)
fun length xs =
	case xs of
		[] => 0
	| 	x::xs' => 1 + (length xs')


(*
	compose : T1 * T2 -> T3
	f : T1
	g : T2
	x : T4

	body being a function : T3 = T4 -> T5
	from g being passed x, T2 = T4 -> T6
	from f being passed the result of g, T1 = T6 -> T7
	T7 = T5

	Put it all together:
	compose : (a' -> b') * (c' -> a') -> ('c -> 'b)
*)
fun compose(f, g) = fn x => f (g x)


(* problems so far *)
(*this piece of code will raise exception*)
(* r : 'a option ref  *)
(*val r = ref NONE*)
(* `:=` has type `'a ref * 'a -> unit`, so instantiate with `string` *)
(*val _ = r := SOME "hi"*)
(* `!` has type `'a ref -> 'a`, so instantiate with `int` *)
(*val i = 1 + valOf(!r)*)

(* Value Restriction *)
(* the downside *)
(*val pairWithOne = List.map (fn x => (x,1))*)
(* workarounds for the downside: wrap in a function binding *)
fun pairWithOneFun xs = List.map (fn x => (x,1)) xs	(* 'a list -> ('a * int) list *)

(* Mutual Recursion *)
(* a state machine implemented via mutual recursion *)
fun match xs =
	let 
		fun s_need_one xs =
			case xs of
				[] => true
			|	1::xs' => s_need_two xs'
			|	_  => false
		and s_need_two xs =
			case xs of
				[] => false
			|	2::xs' => s_need_one xs'
			|	_ => false
	in
		s_need_one xs
	end

(* mutually recursive datatype binding *)
datatype t1 = Foo of int | Bar of t2
and t2 = Baz of string | Quux of t1

(* related functions *)
fun no_zeros_or_empty_strings_t1 x =
	case x of
		Foo i => i <> 0
	|	Bar y => no_zeros_or_empty_strings_t2 y

and no_zeros_or_empty_strings_t2 x =
	case x of
		Baz s => size s > 0
	|	Quux y =>  no_zeros_or_empty_strings_t1 y

(* the above code works find, but we can rewrite in using higher-order function *)
fun no_zeros_or_empty_strings_t1_alternate (f, x) =	(* f : t2 -> bool *)
	case x of
		Foo i => i <> 0
	|	Bar y => f y

fun no_zeros_or_empty_strings_t2_alternate (x) =
	case x of
		Baz s => size s > 0
	|	Quux y =>  no_zeros_or_empty_strings_t1_alternate (no_zeros_or_empty_strings_t2_alternate, y)


(* Module and Signature *)
signature MATHLIB = 
sig
	val fact : int -> int
	val half_pi : real
	(*val doubler : int -> int*)
end

structure MyMathLib :> MATHLIB =
	struct

	fun fact x =
		if x=0
		then 1
		else x * fact (x-1)

	val half_pi = Math.pi / 2.0
	fun doubler y = y + y	(* cannot be used outside the module *)

	end

val pi = MyMathLib.half_pi + MyMathLib.half_pi


(* a more complex module example *)

(* a bad practice of signature *)
signature RATIONAL_A = 
sig
	datatype rational = 
		Whole of int
	|	Frac of int * int
	exception BadFrac
	val make_frac : int * int -> rational
	val add : rational * rational -> rational
	val toString : rational -> string
end

(* a good practice of signature *)
signature RATIONAL_B = 
sig
	type rational
	exception BadFrac
	val make_frac : int * int -> rational
	val add : rational * rational -> rational
	val toString : rational -> string
end

(* another signature C *)
signature RATIONAL_C = 
sig
	type rational
	exception BadFrac
	val Whole : int -> rational 	(* clients only knows `Whole` as a function *)
	val make_frac : int * int -> rational
	val add : rational * rational -> rational
	val toString : rational -> string
end

(* module definition *)
structure Rational1 :> RATIONAL_C = 
struct
	datatype rational = 
		Whole of int
	|	Frac of int * int
	exception BadFrac

	fun gcd (x, y)  =
		if x=y
		then x
		else if x < y
		then gcd(x, y-x)
		else gcd(y, x)

	fun reduce r =
		case r of
			Whole _ => r
		|	Frac(x,y) =>
			if x = 0
			then Whole 0
			else
				let 
					val d = gcd(abs x, y)
				in
					if d=y
					then Whole(x div d)
					else Frac(x div d, y div d)
				end

	fun make_frac(x,y) = 
		if y = 0
		then raise BadFrac
		else if y < 0
		then reduce(Frac(~x, ~y))
		else reduce(Frac(x, y))

	fun add(r1, r2) =
		case (r1, r2) of
			(Whole(i), Whole(j))	=> Whole(i+j)
		|	(Whole(i), Frac(j,k))	=> Frac(j+k*i, k)
		|	(Frac(j,k), Whole(i))	=> Frac(j+k*i, k)
		|	(Frac(a,b), Frac(c,d))	=> reduce(Frac(a*b+b*c, b*d))

	fun toString r =
		case r of
			Whole i => Int.toString i
		|	Frac(a, b) => (Int.toString a) ^ "/" ^ (Int.toString b)
end


(* Equivalent Implementations *)
structure Rational2 :> RATIONAL_C (* or B or C *) = 
struct
	datatype rational = 
		Whole of int
	|	Frac of int * int
	exception BadFrac

	fun make_frac(x,y) = 
		if y = 0
		then raise BadFrac
		else if y < 0
		then Frac(~x, ~y)
		else Frac(x, y)

	fun add(r1, r2) =
		case (r1, r2) of
			(Whole(i), Whole(j))	=> Whole(i+j)
		|	(Whole(i), Frac(j,k))	=> Frac(j+k*i, k)
		|	(Frac(j,k), Whole(i))	=> Frac(j+k*i, k)
		|	(Frac(a,b), Frac(c,d))	=> Frac(a*b+b*c, b*d)

	fun toString r =
		let 
			fun gcd (x, y)  =
				if x=y
				then x
				else if x < y
				then gcd(x, y-x)
				else gcd(y, x)

			fun reduce r =
				case r of
					Whole _ => r
				|	Frac(x,y) =>
					if x = 0
					then Whole 0
					else
						let 
							val d = gcd(abs x, y)
						in
							if d=y
							then Whole(x div d)
							else Frac(x div d, y div d)
						end
		in
			case reduce r of
				Whole i => Int.toString i
			|	Frac(a, b) => (Int.toString a) ^ "/" ^ (Int.toString b)
		end
end


(* Another Equivalent Structure *)
structure Rational3 :> RATIONAL_C = 
struct
	type rational = int * int
	exception BadFrac

	fun make_frac(x,y) = 
		if y = 0
		then raise BadFrac
		else if y < 0
		then (~x, ~y)
		else (x, y)

	fun add((a,b),(c,d)) = (a*d + c*b, b*d)

	fun toString(x, y) =
		if x = 0
		then "0"
		else
			let 
				fun gcd(x,y) =
				if x=y
				then x
				else if x < y
				then gcd(x,y-x)
				else gcd(y,x)

				val d = gcd(abs x, y)
				val num = x div d
				val denom = y div d
			in
				Int.toString num ^ (if denom=1
									then ""
									else "/" ^ (Int.toString denom))
			end

	fun Whole i = (i, 1)
end
