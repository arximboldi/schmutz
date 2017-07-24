;;
;; schmutz - Scheme Unterstüzung
;;
;; Copyright (C) 2017 Juan Pedro Bolivar Puente
;; Distributed under the Boost Software License, Version 1.0.
;; See accompanying file LICENSE or at: http://boost.org/LICENSE_1_0.txt
;;

(use-modules (example module))

(let ((d (dummy)))
  (dummy-foo d)
  (dummy-bar d 42))
(gc)

(func1)
(func2)
(func3 (dummy) 12)
(foo-func1)
(gc)
