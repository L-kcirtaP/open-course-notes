fun double x = 2 * x;
fun incr x = x + 1;
(*  Type is (int -> int) * (int -> int) * int *)
val a_tuple = (double, incr, double(incr 7));
val eighteen = (#1 a_tuple) 9;

(* A function clousure which performs function `f` for n times *)
fun n_times(f, n, x) =
	if n=0
	then x
	else f(n_times(f, n-1, x))

fun increment x = x + 1
fun double x = x + x

val x1 = n_times(double, 4, 10)
val x2 = n_times(increment, 4, 10)
val x3 = n_times(tl, 2, [4, 8, 12, 16])

fun addition(n, x) = n_times(increment, n, x);
fun double_n_times(n, x) = n_times(double, n, x);
fun nth_tail(n, x) = n_times(tl, n, x);

(* a higher-order function that is not polymorphic *)
(* (int -> int) * int -> int *)
fun times_until_zero(f, x) =
	if x=0 then 0 else 1 + times_until_zero(f, f x);

(* a polymorphic function that is not higher-order *)
fun len xs =
	case xs of
		[] => 0
	|	x::xs' => 1+len xs'

(* anonymous function *)
fun triple_n_times(n, x) =
	n_times(fn x => 3*x, n, x);

(* unnecessary function wrapping *)
fun nth_tail(n, xs) = n_times((fn y => tl y), n, xs);	(* inferior *)
fun nth_tail(n, xs) = n_times(tl, n, xs);				(* clean *)

(* map function *)
fun map(f, xs) =
	case xs of
		[] => []
	|	x::xs' => (f x)::map(f, xs');

val x1 = map(tl, [[1, 2, 3], [4, 5,6], [0, 0]]);

(* filter function *)
fun filter(f, xs) =
	case xs of
		[] => []
	|	x::xs' => if f x
	              then x::(filter(f, xs'))
	              else filter(f, xs');

filter((fn x => x>3), [1, 2, 4, 5, 1]);

(* (int -> bool) -> (int -> int) *)
fun double_or_triple f =
	if f 7
	then fn x => 2*x
	else fn x => 3*x;

val double = double_or_triple (fn x => x - 3 = 4);
val nine = double_or_triple (fn x => x = 42) 3;

(* define higher-ordre funciton for custom data structure *)
datatype exp = Constant of int
			 | Negate of int
			 | Add of (int * int)
			 | Multiply of (int * int);

(* (int -> bool) * exp -> bool *)
fun true_of_all_constants(f, e) =
	case e of
		Constant i => f i
	|	Negate e1 => true_of_all_constants(f, Constant e1)
	|	Add(e1, e2) => true_of_all_constants(f, Constant e1) andalso true_of_all_constants(f, Constant e2)
	|	Multiply(e1, e2) => true_of_all_constants(f, Constant e1) andalso true_of_all_constants(f, Constant e2);

(* exp -> bool *)
fun exp_all_even e = true_of_all_constants(fn x => x mod 2 = 0, e);

(* lexical scope for higher-order functions *)
val x = 1;
fun f y = 
	let 
		val x = y+1
	in 
		fn z => x+y+z
	end;

val x = 3;
val g = f 4;
val y = 5;
val z = g 6;

(* lexical scope is able to pass closures that have free variables (private data) *)
fun greaterThanX x = fn y => y > x;
fun noNegatives xs = filter(greaterThanX ~1, xs);
fun allGreater(xs, n) = filter(fn x => x > n, xs);

(* use closures to reduce recomputation *)
fun allShorterThan1(xs, s) =
	filter (fn x => (print "!"; String.size x < String.size s), xs);

fun allShorterThan2(xs, s) =
	let 
		val sz = (print "!"; String.size s)
	in
		filter(fn x => String.size x < sz, xs)
	end;

allShorterThan1(["a", "ab", "abc"], "cd");
allShorterThan2(["a", "ab", "abc"], "cd");

(* fold/reduce: accumulates an answer by repeatedly applying `f` to anster *)
(* ('a * 'b -> 'a ) * 'a * 'b list -> 'a *)
fun fold(f, acc, xs) =
	case xs of 
		[] => acc
	|	x::xs => fold(f, f(acc,x), xs);

fun sumAll xs = fold((fn (x,y) => x+y), 0, xs);
sumAll([1, 2, 3, 4]);

(* example using private data *)
fun noOfIntInRange (xs,lo,hi) =
	fold ((fn (x,y) =>
			x + (if y >= lo andalso y <= hi then 1 else 0)),
			0, xs);
(* write in another way with a helper func *)
fun noOfIntInRangeAgain(xs,lo,hi) =
	let 
		fun foo (g, xs) = fold((fn(x,y) => x + g y), 0, xs)
	in
		foo((fn x => if x >= lo andalso x <= hi then 1 else 0), xs)
	end

(* ('b -> 'c) * ('a -> 'b) -> ('a -> 'c) *)
fun compose(f, g) = fn x => f(g x);

fun sqrt_of_abs i = Math.sqrt (Real.fromInt (abs i));
(* combine function *)
fun sqrt_of_abs_1 i = (Math.sqrt o Real.fromInt o abs) i;
val sqrt_of_abs_2 = Math.sqrt o Real.fromInt o abs;

(* !> infix operator *)
infix !>;
fun x !> f = f x;
fun sqrt_of_abs_3 i = i !> abs !> Real.fromInt !> Math.sqrt;

(* ('a -> 'b option) * ('a -> 'b) -> 'a -> 'b *)
fun backup (f,g) = fn x => case f of 
							NONE => g x
						|	SOME y => y;

(* Currying *)
fun sorted3_tupled (x, y, z) = z >= y andalso y >= x;
val sorted = sorted3_tupled(7, 9, 11);

val sorted3 = fn x => fn y => fn z => z >= y andalso y >= x;
val sorted = ((sorted3 7) 9) 11;
val sorted = sorted3 7 9 11;		(* a syntactic sugar *)
(* syntactic sugar for currying *)
fun sorted3_nicer x y z = z >= y andalso y >= x;
(* curried fold function *)
fun fold_curried f acc xs =
	case xs of 
		[] => acc
	|	x::xs' => fold_curried f (f(acc,x)) xs';

(* partial application *)
val is_nonnegative = sorted3 0 0;				(* check if a number is non-negative *)
val sum = fold_curried (fn (x,y) => x+y) 0;		(* sum an integer list *)

(* a very elegant function using partial application *)
fun range i j = if i > j then [] else i :: range (i+1) j;
val countup = range 1;							(* get back a closure *)
countup 10;

fun exists predicate xs =
	case xs of
		[] => false
	|	x::xs' => predicate x orelse exists predicate xs'

val thereIsSeven = exists (fn x => x=7);
thereIsSeven [1, 3, 5, 9];						(* false *)

(* the built-in map function is curried *)
val incrementAll = List.map (fn x => x+1);
(* so as foldl, List.filter, etc. *)
val removeZeros = List.filter (fn x => x <> 0);

(* value restriction *)
val pariWithOne = List.map (fn x => (x,1));		(* this will raise a warning *)
val pariWithOne : string list -> (string * int) list = List.map (fn x => (x, 1));

(* currying wrapup *)
fun curry f = fn x => fn y => f(x,y);
fun uncurry f(x,y) = f x y;
fun other_curry f x y = f y x;

fun range_uncurried (i,j) = if i > j then [] else i::range_uncurried(i+1,j);
val countup = curry range_uncurried 1;
val countfrom = other_curry (curry range_uncurried) 10;
countfrom 3;

(* mutable reference *)
val x = ref 42;
val y = ref 42;
val z = x;
x := 43;
(!y) + (!z);

(* callback *)
(* public library interface: a function for registering new callbacks *)
val cbs : (int -> unit) list ref = ref [];
fun onKeyEvent f = cbs := f::(!cbs);

fun onEvent i =
	let fun loop fs =
		case fs of 
			[] => ()
		|	f::fs' => (f i; loop fs')
	in loop (!cbs) end;

(* for client *)
val timesPressed = ref 0;
val _ = onKeyEvent (fn _ => timesPressed := (!timesPressed) + 1);

fun printIfPressed i =
	onKeyEvent (fn j => if i=j
						then print ("you pressed " ^ Int.toString i ^ "\n")
						else ());

val _ = printIfPressed 1;
val _ = printIfPressed 2;
val _ = printIfPressed 3;
cbs;							(* ref [fn,fn,fn, fn] : (int -> unit) list ref *)

(* abstract data type *)
datatype set = s of { insert : int -> set,
					  member : int -> bool,
					  size : unit -> int }
(*
fun use_sets () =
	let val S s1 = empty_set
		val S s2 = (#insert s1) 34
		val S s3 = (#insert s2) 34
		val S s4 = #insert s3 19
	in
		if (#member s4) 42
		then 99
		else if (#member s4) 19
		then 17 + (#size s3) ()
		else ()
	end;
*)
(*
val empty_set = 
	blahblahblah
*)
