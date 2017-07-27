//
// schmutz - Scheme Unterstüzung
//
// Copyright (C) 2017 Juan Pedro Bolivar Puente
// Distributed under the Boost Software License, Version 1.0.
// See accompanying file LICENSE or at: http://boost.org/LICENSE_1_0.txt
//

#include <scm/scm.hpp>

#include <numeric>

namespace {

int free_fn() { return 42; }

struct foo
{
    std::size_t count_;
    auto count() const { return count_; }
    void update() { ++count_; }
    foo updated() { return { count_ + 1 }; }
};

struct bar
{
    static std::size_t constructor_count;
    static std::size_t destructor_count;

    bar()  { ++constructor_count; }
    ~bar() { ++destructor_count; }
};

std::size_t bar::constructor_count = 0;
std::size_t bar::destructor_count = 0;

struct baz
{
    struct lol {};
    baz(lol) {};
    auto get() const { return 42; }
};
static auto baz_finalizer_count = 0;

} // anonymous

extern "C"
void init_module()
{
    scm::group()
        .define("fn-free", free_fn)
        .define("fn-lambda", [] { return 42; })
        .define("fn-arguments", [] (int a, double b) { return a + b; })
        .define("fn-variadic", [] (int fst, scm::args xs) {
            using namespace std;
            return accumulate(begin(xs), end(xs), fst, std::plus<int>{});
        })
        .define("fn-high-order", [] (scm::val value, int count, scm::val fn) {
            using namespace std;
            while (count --> 0)
                value = fn(value);
            return value;
        })
        ;

    scm::group("tst")
        .define("free", free_fn)
        .define("lambda", [] { return 42; });

    scm::type<foo>("foo")
        .constructor()
        .maker()
        .define("count", &foo::count)
        .define("update!", &foo::update)
        .define("update", &foo::updated)
        ;

    scm::type<bar>("bar")
        .constructor()
        .finalizer()
        .define("constructor-count", [] { return bar::constructor_count; })
        .define("destructor-count", [] { return bar::destructor_count; })
        ;

    scm::type<baz>("baz")
        .constructor([] (int x, int y) { return x + y; })
        .maker([] { return baz{{}}; })
        .finalizer([] (baz&) { ++baz_finalizer_count; })
        .define("finalizer-count", [] { return baz_finalizer_count; })
        ;
}
