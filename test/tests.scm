;;
;; schmutz - Scheme Unterstüzung
;;
;; Copyright (C) 2017 Juan Pedro Bolivar Puente
;; Distributed under the Boost Software License, Version 1.0.
;; See accompanying file LICENSE or at: http://boost.org/LICENSE_1_0.txt
;;

(use-modules (srfi srfi-64))

(test-runner-current (test-runner-create))

(test-group "some tests1"
  (test-eq 42 (* 21 2)))

(test-group "some tests2"
  (test-assert (= 42 (* 21 2))))

(exit (test-runner-fail-count (test-runner-current)))
