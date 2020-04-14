(* ML Variable Binding and Expressions *)

val x = 42;
(*static environment: x: int*)
(*dynamic environment: x --> 42*)

val y = 21;
(*static environment: x: int, y: int*)
(*dynamic environment: x --> 42, y --> 21*)

val z = (x + y) + (y + 2);
(*static environment: x: int, y: int, z: int*)
(*dynamic environment: x --> 42, y --> 21, z --> 86*)

val q = z + 1;
(*static environment: x: int, y: int, z: int, q: int*)
(*dynamic environment: x --> 42, y --> 21, z --> 86, q --> 87*)

val abs_of_z = if z < 0 then 0 - z else z; (* bool *) (* int *)
(*static environment: abs_of_z: int*)
(*dynamic environment: ..., abs_of_z --> 70*)

val abs_of_z_simpler = abs z
(*function call*)

(* Shadowing *)
val a = 10;
val b = a * 2;
val a = 5; (* this is not an assignment expression *)
val c = b;
val d = a;
val a = a + 1;
val f = a * 2;

(* Function *)
fun pow(x: int, y: int) = 
    if y = 0
    then 1
    else x * pow(x, y-1)

val fortytwo = pow(2, 2+3) + pow(3, 2) + pow(5, 0)

fun swap (pr : int*bool) = 
    (#2 pr, #1 pr)

(* (int*int) * (int*int) -> int *)
fun sum_two_pair (pr1 : int*int, pr2 : int*int) = 
    (#1 pr1) + (#2 pr1) + (#1 pr2) + (#2 pr2)

(* int * int -> int*int *)
fun div_mod (x : int, y : int) = 
    (x div y, x mod y)

val x1 = (7, (true, 9)) (* int * (bool*int) *)
val x2 = #1 (#2 x1)     (* bool *)

fun sum_list (xs : int list) =
    if null xs
    then 0
    else hd xs + sum_list(tl xs)

fun countdown (x : int) =
    if x = 0
    then []
    else x :: countdown(x-1)

fun append (xs : int list, ys : int list) = 
    if null xs
    then ys
    else (hd xs) :: append((tl xs), ys)

(* functions over list of pairs *)
val pairlist = [(3, 4), (5, 6)]
fun sum_pair_list (xs: (int * int) list) = 
    if null xs
    then 0
    else #1 (hd xs) + #2 (hd xs) + sum_pair_list(tl xs)

fun firsts (xs : (int * int) list) = 
    if null xs
    then []
    else (#1 (hd xs)) :: firsts(tl xs)

fun seconds (xs : (int * int) list) = 
    if null xs
    then []
    else (#2 (hd xs)) :: seconds(tl xs)

fun sum_pair_list2 (xs: (int * int) list) = 
    if null xs
    then 0
    else sum_list(firsts(xs)) + sum_list(seconds(xs))

val fsts = firsts pairlist
val sum = sum_pair_list2 pairlist

fun silly1 (z : int) = 
    let
        val x = if z > 0 then z else 42
        val y = x + z + 9
    in 
        if x > y then x * 2 else y * y
    end
(* type of silly1: int -> int *)

fun silly2 () =
    let
        val x = 1
    in
        (let val x = 2 in x+1 end) + (let val y = x+2 in y+1 end)
        (* the first x is shadowing *)
    end

fun countup_from1(x : int) = 
    let
        fun count (from : int) = 
            if from=x
            then x::[]
            else from :: count(from+1)
    in
        count 1
    end

val cf1 = countup_from1 10

(* bad efficiency with repeated recursion *)
fun bad_max (xs : int list) =   
    if null xs
    then 0
    else if null (tl xs)
    then hd xs
    else if hd xs > bad_max(tl xs)
    then hd xs
    else bad_max(tl xs)
(* finding max of countup(50) will takes 2^50 computation! *)

fun good_max (xs : int list) = 
    if null xs
    then 0
    else if null (tl xs)
    then hd xs
    else
        let val tl_ans = good_max(tl xs)
        in 
            if hd xs > tl_ans
            then hd xs
            else tl_ans
        end

val gm = good_max(countup_from1(100))

(* good_max return 0 when input list is empty: this is bad *)
(* use option *)
fun better_max (xs: int list) = 
	if null xs
	then NONE
	else
		let val tl_ans = better_max(tl xs)
		in 
			if isSome tl_ans andalso valOf tl_ans > hd xs
			then tl_ans
			else SOME (hd xs)
		end

val gm_option = better_max(countup_from1(100))

(* but better_max check empty each time, let's make it cleaner *)
fun best_max (xs: int list) = 
	if null xs
	then NONE
	else 
		let
			fun max_nonempty (xs: int list) =
				if null (tl xs)
				then hd xs
				else 
					let val tl_ans = max_nonempty(tl xs)
					in
						if hd xs > tl_ans
						then hd xs
						else tl_ans
					end
		in 
			SOME (max_nonempty xs)
		end


(* These two are indistinguishable *)
fun sort_pair_1 (pr: int * int) =
	if #1 pr < #2 pr
	then pr
	else (#2 pr, #1 pr)

fun sort_pair_2 (pr: int * int) =
	if #1 pr < #2 pr
	then (#1 pr, #2 pr)
	else (#2 pr, #1 pr)
		


















