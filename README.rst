
.. image:: https://travis-ci.org/arximboldi/schmutz.svg?branch=master
   :target: https://travis-ci.org/arximboldi/schmutz
   :alt: Travis Badge

.. image:: https://codecov.io/gh/arximboldi/schmutz/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/arximboldi/schmutz
   :alt: CodeCov Badge

.. raw:: html

   <img width="100%" src="https://cdn.rawgit.com/arximboldi/schmutz/375ad78e/doc/_static/logo-front.svg" alt="Logotype"/>


.. include:introduction/start
..

.. rubric:: *SCHeMe UnterstüTZung*

**schmutz** is a library to declare Scheme bindings for C++ code using a
simple embedded DSL.  Think of it as `Boost.Python`_ or LuaBind_ but
for Scheme.  At the moment, it only works with the `GNU Guile`_ Scheme
implementation, but multiple backend support is considered for the
future.

.. _Boost.Python: http://www.boost.org/libs/python
.. _LuaBind: https://github.com/luabind/luabind
.. _GNU Guile: https://www.gnu.org/software/guile/manual/guile.html

* **Documentation** (Contents_)
* **Code** (GitHub_)

.. _contents: https://sinusoid.es/schmutz/#contents
.. _github: https://github.com/arximboldi/schmutz

  This is a *pro bono* research project by `Sinusoidal Engineering
  <http://sinusoid.al/>`_.  **To ensure its long term development
  please consider becoming a sponsor or hiring us:** juanpe@sinusoid.al

.. include:index/end

Example
-------

.. rubric:: In the C++ world...

.. code-block:: c++

   #include <scm/scm.hpp>
   #include <numeric>

   class counter {
       std::size_t count_ = 0;
   public:
       std::size_t get() const { return count_; }
       void tick() { ++count_; }
   };

   int fold_args(scm::val fn, scm::val fst, scm::args xs) {
       return std::accumulate(xs.begin(), xs.end(), fst, fn);
   }

   extern "C" void init_module() {
       scm::type<counter>("counter")
           .constructor()
           .define("get", &counter::get)
           .define("tick!", &counter::tick);
       scm::group()
           .define("the-answer", [] { return 42; })
           .define("fold-args", fold_args);
   }

.. rubric:: In the Scheme world...
.. code-block:: scheme

   (use-modules (example module)
                (oop goops)
                (rnrs base))

   (let ((cnt (counter)))
     (assert (is-a? cnt <counter>))
     (counter-tick! cnt)
     (counter-tick! cnt)
     (counter-tick! cnt)
     (assert (= 3 (counter-get cnt))))

   (assert (= (the-answer) 42))
   (assert (= 6 (fold-args + 0 1 2 3)))

Usage
-----

This is a **header only** library.  As long as you already have Guile
installed, you can just copy the ``scm`` subfolder somewhere in your
*include path*.

Otherwise, if you are using the `Guix package manager`_ you can just::

    git clone https://github.com/arximboldi/schmutz
    guix package -f schmutz/guix.scm -i

Or if you are using the `Nix package manager`_ you can just::

    nix-env -if https://github.com/arximboldi/schmutz/archive/master.tar.gz

Alternatively, you can use `CMake`_ to install the library in your
system once you have manually cloned the repository::

    mkdir -p build && cd build
    cmake .. && sudo make install

.. _guix package manager: https://www.gnu.org/software/guix
.. _nix package manager: https://nixos.org/nix
.. _cmake: https://cmake.org

Development
-----------

In order to develop the library, you will need to compile and run the
examples, tests and benchmarks.  These require some additional tools.
The easiest way to install them is by using the `Guix package manager`_
or the `Nix package manager`_.  At the root of the repository just
type::

    guix environment -l guix.scm

Or alternatively::

    nix-shell

This will download all required dependencies and create an isolated
environment in which you can use these dependencies, without polluting
your system.

Then you can proceed to generate a development project using `CMake`_::

    mkdir build && cd build
    cmake ..

From then on, one may build and run all tests by doing::

    make check

License
-------

This software is licensed under the
**Boost Software License, Version 1.0.**

----

.. code-block:: plain

   schmutz - Scheme Unterstüzung
   Copyright (C) 2017 Juan Pedro Bolivar Puente

   Boost Software License - Version 1.0 - August 17th, 2003

   Permission is hereby granted, free of charge, to any person or
   organization obtaining a copy of the software and accompanying
   documentation covered by this license (the "Software") to use,
   reproduce, display, distribute, execute, and transmit the Software,
   and to prepare derivative works of the Software, and to permit
   third-parties to whom the Software is furnished to do so, all
   subject to the following:

   The copyright notices in the Software and this entire statement,
   including the above license grant, this restriction and the
   following disclaimer, must be included in all copies of the
   Software, in whole or in part, and all derivative works of the
   Software, unless such copies or derivative works are solely in the
   form of machine-executable object code generated by a source
   language processor.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE AND
   NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE
   DISTRIBUTING THE SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER
   LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
   DEALINGS IN THE SOFTWARE.
