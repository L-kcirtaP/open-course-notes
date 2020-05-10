#lang racket

; make all definitions available to other files (as a module)
(provide (all-defined-out))

; basic definition
(define x 3)         ; val x = 3
(define y (+ x 2))   ; val y = x + 2

(define cube1
  (lambda (x)
    (* x (* x x))))  ; same as (* x x x)

(define (cube2 x)
  (* x x x))         ; syntactic sugar

(define (pow1 x y)
  (if (= y 0)
      1
      (* x (pow1 x (- y 1)))))

; Curring in Racket
(define pow2
  (lambda (x)
    (lambda (y)
      (pow1 x y))))

(define three-to-the (pow2 3))

; List
(define (sum xs)
  (if (null? xs)
      0
      (+ (car xs) (sum (cdr xs)))))          
  
; append
(define (my-append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (my-append (cdr xs) ys))))

; map
(define (my-map f xs)
  (if (null? xs)
      null
      (cons (f (car xs))
            (my-map f (cdr xs)))))

; Parentheses Matter
(define (fact n) (if (= n 0) 1 (* n (fact (- n 1)))))

; Dynamic Typing
(define xs (list 1 2 3 4 5))
(define ys (list (list 4 5) 6 7 (list 8 9 10)))
; works for number lists and nested number lists
(define (sum1 xs)
  (if (null? xs)
      0
      (if (number? (car xs))
          (+ (car xs) (sum1 (cdr xs)))
          (+ (sum1 (car xs)) (sum1 (cdr xs))))))

(define zs (list "hi" (list 1 2 3) 4 5 (list 8)))
; updated `sum1` to treat other items (e.g. string) as `0`
(define (sum2 xs)
  (if (null? xs)
      0
      (if (number? (car xs))
          (+ (car xs) (sum2 (cdr xs)))
          (if (list? (car xs))
              (+ (sum2 (car xs)) (sum2 (cdr xs)))
              (sum2 (cdr xs))))))
