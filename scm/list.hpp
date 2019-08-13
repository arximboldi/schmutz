//
// schmutz - Scheme Unterstüzung
//
// Copyright (C) 2017 Juan Pedro Bolivar Puente
// Distributed under the Boost Software License, Version 1.0.
// See accompanying file LICENSE or at: http://boost.org/LICENSE_1_0.txt
//

#pragma once

#include <scm/val.hpp>
#include <iostream>

namespace scm {

/**
 * C++ representation of a Scheme list.
 *
 * Like Scheme values, this type has *reference semantics*.  Copying a
 * `scm::list` just copies a pointer or handle to the underlying Scheme
 * list, thus just creating a new *alias*.  Mutations to the
 * referenced Scheme list are visible through all the aliases.
 */
struct list : detail::wrapper
{
    using base_t = detail::wrapper;
    using base_t::base_t;

    using iterator = list;
    using value_type = val;

    list() : base_t{SCM_EOL} {};
    list end() const { return {}; }
    list begin() const { return *this; }

    explicit operator bool() { return handle_ != SCM_EOL; }

    val operator* () const { return val{scm_car(handle_)}; }

    list& operator++ ()
    {
        handle_ = scm_cdr(handle_);
        return *this;
    }

    list operator++ (int)
    {
        auto result = *this;
        result.handle_ = scm_cdr(handle_);
        return result;
    }
};


  /**
   * Creates a (wrapped) scheme list of the arguments passed to listify.
   *
   * We couldn't make this a constructor for list because it would be
   * confused with the copy constructor.
   * It also not called make_list because there is already a
   * scheme side constructor with the same name and different meaning
   */
list listify() { return list{}; }
list listify(val a0) { return scm_list_1(a0); }
list listify(val a0, val a1) { return scm_list_2(a0, a1); }
list listify(val a0, val a1, val a2) { return scm_list_3(a0, a1, a2); }
list listify(val a0, val a1, val a2, val a3)
{ return scm_list_4(a0, a1, a2, a3); }
list listify(val a0, val a1, val a2, val a3, val a4)
{ return scm_list_5(a0, a1, a2, a3, a4); }

template<typename...T, typename = std::enable_if_t<(sizeof...(T) > 5), void>>
list listify(T...arg){
  return scm_list_n(arg...,SCM_UNDEFINED);
}

/**
 * C++ representation of a Scheme list that when used at the end of a
 * function, will capture the *rest* arguments.
 */
struct args : list
{
    using list::list;
};

} // namespace scm

SCM_DECLARE_WRAPPER_TYPE(scm::list);
SCM_DECLARE_WRAPPER_TYPE(scm::args);
