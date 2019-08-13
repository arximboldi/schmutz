;;
;; schmutz - Scheme Unterstüzung
;;
;; Copyright (C) 2017 Juan Pedro Bolivar Puente
;; Distributed under the Boost Software License, Version 1.0.
;; See accompanying file LICENSE or at: http://boost.org/LICENSE_1_0.txt
;;

(use-modules (srfi srfi-1)
             (srfi srfi-64)
             (oop goops)
             (test module))

(test-runner-current (test-runner-create))

(test-group "group definitions"
  (test-eq "free function"
    42
    (fn-free))
  (test-eq "lambda function"
    42
    (fn-lambda))
  (test-eqv "function with arguments"
    2.5
    (fn-arguments 1 1.5))
  (test-eq "higher order function"
    64
    (fn-high-order 1 6 (lambda (x) (+ x x)))))

(test-group "named group definitions"
  (test-eq "free function"
    42
    (tst-free))
  (test-eq "lambda function"
    42
    (tst-lambda)))

(test-group "type definitions"
  (test-assert "constructor"
    (is-a? (foo)
           <foo>))
  (test-assert "maker"
    (is-a? (make-foo)
           <foo>))
  (test-eq "method"
    0
    (foo-count (foo)))
  (test-eq "update"
    1
    (let ((x (foo)))
      (foo-update! x)
      (foo-count x)))
  (let ((x (foo)))
    (test-eq "pure update"
      1 (foo-count (foo-update x)))
    (test-eq "pure update respects old value"
      0 (foo-count x))))

(test-group "type lifetime"
  (test-eq "constructor not called yet"
    0 (bar-constructor-count))
  (test-eq "destructor not called yet"
    0 (bar-destructor-count))
  (let ((x (bar)))
    (test-eq "constructor called"
      1 (bar-constructor-count))
    (test-eq "destructor not called yet"
      0 (bar-destructor-count)))
  (gc)
  (test-eq "constructor not called again"
    1 (bar-constructor-count))
  (test-eq "destructor called now"
    1 (bar-destructor-count)))

(test-group "custom type lifetime"
  (test-eq "custom constructor"
    5
    (baz 2 3))
  (test-assert "custom maker"
    (is-a? (make-baz) <baz>))
  (gc)
  (test-eq "custom finalizer"
    1
    (baz-finalizer-count)))

(exit (test-runner-fail-count (test-runner-current)))
