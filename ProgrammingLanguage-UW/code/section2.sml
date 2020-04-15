val x = {bar=(1+2, true andalso true), foo=3+4, baz=(false,9)};
#bar x;

(* tuple is the syntactic sugar of record *)
val a_pair = (3+1, 4+2);
val a_record = {second=4+2, first=3+1}
val another_pair = {2=5, 1=6};
val x = {3="hi", 1=5};
val y = {3="hi", 1=5, 2=true};	(* note that y is a triple *)

(* datatype binding *)
datatype mytype = TwoInts of int * int
				| Str of string
				| Pizza;

val a = Str "hi"			(* Str is a construct *)
val b = Str
val c = Pizza
val d = TwoInts(1+2, 3+4)
val e = a

(* case expression *)
(* type of f: mytype -> int *)
fun f (x : mytype) =
	case x of 
		Pizza => 42
	|	Str s => 0
	|	TwoInts(i1,i2) => i1 + i2;

f(TwoInts(7, 9));

datatype suit = Club | Diamond | Heart | Spade
datatype rank = Jack | Queen | King | Ace | Num of int

datatype exp = Constant	of int
			 | Negate 	of exp
			 | Add 		of exp * exp
			 | Multiply	of exp * exp;

fun eval e = 
	case e of 
		Constant i 			=> i
	  | Negate e2			=> ~(eval e2)
	  | Add (e1, e2)		=> (eval e1) + (eval e2)
	  | Multiply (e1, e2)	=> (eval e1) * (eval e2);

eval (Add (Constant (10+9), Negate (Constant 4)));

fun max_constant e =
	case e of 
		Constant i => i
	  | Negate e2 => max_constant e2
	  | Add (e1, e2) => Int.max(max_constant e1, max_constant e2)
	  | Multiply (e1, e2) => Int.max(max_constant e1, max_constant e2);

max_constant (Add (Constant (10+9), Negate (Constant 4)));

(* Type Synonyms *)
type card = suit * rank;

fun is_Queen_of_Spades(c : card) =
	#1 c = Spade andalso #2 c = Queen;

is_Queen_of_Spades (Diamond, Queen);

fun is_Queen_of_Spades_2 c =
	case c of
		(Spade, Queen) => true
	   | _ => false


fun sum_list xs =
	case xs of 
		[] => 0
	  | x::xs' => x + sum_list xs';

fun append (xs, ys) =
	case xs of 
		[] => ys
		| x::xs' => x :: append(xs', ys);

(* Define polymorphic datatypes *)
datatype 'a myoption = NONE | SOME of 'a;
datatype 'a mylist = Empty | Cons of 'a * 'a mylist;

(* BST: 'b is possibly different from 'a *)
datatype ('a, 'b) tree =
	Node of 'a * ('a, 'b) tree * ('a, 'b) tree
  | Leaf of 'b;
(* As a result, we define a new type `('a, 'b) tree` *)

fun sum_tree tr = 
	case tr of
		Leaf i => i
	  | Node (i, lft, rgt) => i + sum_tree lft + sum_tree rgt;

fun sum_leaves tr =
	case tr of 
		Leaf i => i
	  | Node (i, lft, rgt) => sum_leaves lft + sum_leaves rgt;

val tr = Node((1, Leaf(2), Leaf(3)));
sum_tree tr;
sum_leaves tr;

(* Bad style: use constructor pattern in val-binding *)
(* e.g., val NONE = SOME 2; *)
(* This will raise a RunTime exception: nonexhaustive binding failure *)

(* OK style *)
fun sum_triple_ok triple =
	let val (x, y, z) = triple
	in x + y + z end

fun full_name_ok r = 
	let val {first=x, middle=y, last=z} = r
	in x ^ " " ^ y ^ " " ^ z end

(* Great style: use pattern in function argument *)
fun sum_triple (x, y, z) =
	x + y + z

fun full_name {first=x, middle=y, last=z} =
	x ^ " " ^ y ^ " " ^ z

(* Type is int * 'a * int -> int *)
fun some_sum (x, y, z) =
	x + z
 
(* ''a * ''a -> string *)
fun same_stuff (x, y) =
	if x=y then "yes" else "no";
(* type is int -> string*)
fun is_three x = 
	if x=3 then "yes" else "no";

(* Nested Patterns *)
exception ListLengthMismatch;

(* bad style *)
fun old_zip3 (l1, l2, l3) =
	if null l1 andalso null l2 andalso null l3
	then []
	else if null l1 orelse null l2 orelse null l3
	then raise ListLengthMismatch
	else ( hd l1, hd l2, hd l3 ) :: old_zip3( tl l1, tl l2, tl l3 );

fun zip3 list_triple =
	case list_triple of
		([], [], []) => []
	|   (hd1 :: tl1, hd2 :: tl2, hd3 :: tl3) => (hd1, hd2, hd3)::zip3(tl1, tl2, tl3)
	|	_ => raise ListLengthMismatch;

fun unzip3 lst =
	case lst of
		[] => ([], [], [])
	|	(x, y, z) :: tl =>	let val (l1, l2, l3) = unzip3 tl
							in
								(a::l1, b::l2, c::l3)
							end;
(* int list -> bool *)
fun nondecreasing xs =
	case xs of
		[] => true
	| 	_::[] => true
	| 	head :: (neck::rest) => head <= neck andalso nondecreasing (neck::rest);

datatype sgn = P | N | Z;

(* int * int -> sgn *)
fun multsign (x1, x2) =
	let fun sign x = if x=0 then Z else if x > 0 then P else N
	in 
		case (sign x1, sign x2) of
			(Z, _) => Z
		|	(_, Z) => Z
		|	(P, P) => P
		| 	(N, N) => P
		|	_ => N 			(* be careful with using _, may be nonexhuasted *)
	end;

fun len xs =
	case xs of 
		[] => 0
	|	_::xs' => 1 + len xs';


fun hd xs =
	case xs of
		[] => raise List.Empty
	|	x::_ => x;

exception MyUndesireableCondition;

fun mydiv (x, y) =
	if y=0
	then raise MyUndesireableCondition
	else x div y;

(* int list * exn -> int *)
fun maxlist (xs, ex) =
	case xs of
		[] => raise ex
	|	x::[] => x
	|	x::xs' => Int.max(x, maxlist(xs', ex));

maxlist([1, 2, 3, 0], MyUndesireableCondition);
(* handle exception *)
val handler = maxlist([], MyUndesireableCondition)
	handle MyUndesireableCondition => 42;

(* tail recursion *)
fun fact n =
	let
		fun aux (n, acc) =
			if n=0
			then acc
			else aux (n-1, acc*n)
	in
		aux(n, 1)
	end;

fact 10;

(* reverse a list *)
fun rev xs =
	case xs of
		[] => []
	|	x::xs' => (rev cs) @ [x]

fun rev_tail xs =
	let 
		fun aux (xs, acc) =
			case xs of
				[] => acc
			|	x::xs' => aux(xs', x::acc)
	in
		aux(xs, [])
	end;

rev_tail([1, 2, 3, 4]);
