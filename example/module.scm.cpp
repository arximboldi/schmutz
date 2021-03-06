//
// schmutz - Scheme Unterstüzung
//
// Copyright (C) 2017 Juan Pedro Bolivar Puente
// Distributed under the Boost Software License, Version 1.0.
// See accompanying file LICENSE or at: http://boost.org/LICENSE_1_0.txt
//

#include <scm/scm.hpp>
#include <numeric>

struct dummy
{
    SCM port_ = scm_current_warning_port();

    dummy(dummy&&)
    { scm_puts("~~ dummy move constructor\n", port_); }

    dummy()
    { scm_puts("~~ dummy default constructor\n", port_); }

    ~dummy()
    { scm_puts("~~ dummy finalized\n", port_); }

    void foo()
    { scm_puts("~~ dummy foo\n", port_); }

    int bar(int x)
    {
        auto res = x + 42;
        scm_puts("~~ dummy bar: ", port_);
        scm_display(scm::val{res}, port_);
        scm_newline(port_);
        return res;
    }
};

template <int I>
void func()
{
    auto port = scm_current_warning_port();
    scm_puts("~~ func", port);
    scm_display(scm_from_int(I), port);
    scm_newline(port);
}

class counter
{
    std::size_t count_ = 0;
public:
    std::size_t get() const { return count_; }
    void tick() { ++count_; }
};

int fold_args(scm::val fn, scm::val fst, scm::args xs)
{
    return std::accumulate(xs.begin(), xs.end(), fst, fn);
}

struct bar_tag_t {};

extern "C"
void init_module()
{
    scm::type<counter>("counter")
        .constructor()
        .define("get", &counter::get)
        .define("tick!", &counter::tick);

    scm::group()
        .define("the-answer", [] { return 42; })
        .define("fold-args", fold_args);

    scm::type<dummy>("dummy")
        .constructor()
        .finalizer()
        .define("foo", &dummy::foo)
        .define("bar", &dummy::bar);

    scm::group()
        .define("func1", func<1>);

    scm::group<bar_tag_t>()
        .define("func2", func<2>)
        .define("func3", &dummy::bar);

    scm::group("foo")
        .define("func1", func<1>)
        .define("sum-all", fold_args);
}
