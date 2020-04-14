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





