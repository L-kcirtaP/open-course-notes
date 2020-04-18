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

(* define higher-ordre funciton custom data structure *)
datatype exp = Constant of int
			 | Negagte of int
			 | Add of (int * int)
			 | Multiply of (int * int);

(* (int -> bool) * exp -> bool *)
fun true_of_all_constants(f, e) =
	case e of
		Constant i => f i
	|	Negate e1 => true_of_all_constants(f, e1)
	|	Add(e1, e2) => true_of_all_constants(f, e1) andalso true_of_all_constants(f, e2)
	|	Multiply(e1, e2) => true_of_all_constants(f, e1) andalso true_of_all_constants(f, e2);

(* exp -> bool *)
fun exp_all_even e = true_of_all_constants(fn x => x mod 2 = 0, e);




