//
// schmutz - Scheme Unterstüzung
//
// Copyright (C) 2017 Juan Pedro Bolivar Puente
// Distributed under the Boost Software License, Version 1.0.
// See accompanying file LICENSE or at: http://boost.org/LICENSE_1_0.txt
//

#pragma once

#include <scm/detail/convert.hpp>

namespace scm {
namespace detail {

template <typename T>
struct convert_wrapper_type
{
    static T to_cpp(SCM v) { return T{v}; }
    static SCM to_scm(T v) { return v.get(); }
};

struct wrapper
{
    wrapper() = default;
    wrapper(SCM hdl) : handle_{hdl} {}
    SCM get() const { return handle_; }
    operator SCM () const { return handle_; }

    bool operator==(wrapper other) { return handle_ == other.handle_; }
    bool operator!=(wrapper other) { return handle_ != other.handle_; }

protected:
    SCM handle_ = SCM_UNSPECIFIED;
};

struct big
{};
struct small
{};
template <typename... T>
using scm_call_size = std::conditional_t<(sizeof...(T) <= 9), small, big>;

template <int nargs>
constexpr auto dispatch_small_scm_call()
{
    if (nargs == 0)
        return scm_call_0;
    else if (nargs == 1)
        return scm_call_1;
    else if (nargs == 2)
        return scm_call_2;
    else if (nargs == 3)
        return scm_call_3;
    else if (nargs == 4)
        return scm_call_4;
    else if (nargs == 5)
        return scm_call_5;
    else if (nargs == 6)
        return scm_call_6;
    else if (nargs == 7)
        return scm_call_7;
    else if (nargs == 8)
        return scm_call_8;
    else if (nargs == 9)
        return scm_call_9;
}

template <typename... T>
SCM scm_funcall_dispatch(small, SCM f, T... arg)
{
  return dispatch_small_scm_call()(f,arg...);
}

template <typename... T>
SCM scm_funcall_dispatch(big, SCM f, T... arg)
{
    return scm_call(f, arg..., SCM_UNDEFINED);
}

template <typename... T>
SCM scm_funcall_impl(SCM f, T... arg)
{
    return scm_funcall_dispatch(scm_call_size<T...>{}, arg...);
}
} // namespace detail

/**
 * C++ representation of a  Scheme value.
 *
 * Like Scheme values, this type has *reference semantics*.  Copying a
 * `scm::val` just copies a pointer or handle to the underlying Scheme
 * object, thus just creating a new *alias*.  Mutations to the
 * referenced Scheme object are visible through all the aliases.
 */
struct val : detail::wrapper
{
    using base_t = detail::wrapper;
    using base_t::base_t;

    /**
     * Implicit conversion from a C++ type to a Scheme value.  The C++
     * object is always copied.
     */
    template <typename T,
              typename = std::enable_if_t<
                  (!std::is_same<std::decay_t<T>, val>{} &&
                   !std::is_same<std::decay_t<T>, SCM>{})>>
    val(T&& x)
        : base_t(detail::to_scm(std::forward<T>(x)))
    {}

    /**
     * Implicit conversion from a Scheme value to a C++ type.  If the
     * type is a custom type, the conversion may just return a
     * reference to the underlying C++ object.
     */
    template <typename T,
              typename = std::enable_if_t<
                  std::is_same<T, decltype(detail::to_cpp<T>(SCM{}))>{}>>
    operator T() const { return detail::to_cpp<T>(handle_); }

    template <typename T,
              typename = std::enable_if_t<
                  std::is_same<T&, decltype(detail::to_cpp<T>(SCM{}))>{}>>
    operator T& () const { return detail::to_cpp<T>(handle_); }

    template <typename T,
              typename = std::enable_if_t<
                  std::is_same<const T&, decltype(detail::to_cpp<T>(SCM{}))>{}>>
    operator const T& () const { return detail::to_cpp<T>(handle_); }

    /**
     * Function call operator.  If value holds a Scheme procedure,
     * calls the Scheme procedure with the given arguments.  They
     * arguments may be implicitly converted from C++.
     */
    template <typename... T>
    val operator()(T... arg) const
    {
      return detail::scm_funcall_impl(get(),arg...);
    }
};

} // namespace scm

#define SCM_DECLARE_WRAPPER_TYPE(cpp_name__)                            \
    namespace scm {                                                     \
    namespace detail {                                                  \
    template <>                                                         \
    struct convert<cpp_name__>                                          \
        : convert_wrapper_type<cpp_name__> {};                          \
    }} /* namespace scm::detail */                                      \
    /**/

SCM_DECLARE_WRAPPER_TYPE(val);
