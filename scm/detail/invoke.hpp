//
// schmutz - Scheme Unterstüzung
//
// Copyright (C) 2017 Juan Pedro Bolivar Puente
// Distributed under the Boost Software License, Version 1.0.
// See accompanying file LICENSE or at: http://boost.org/LICENSE_1_0.txt
//

#pragma once

// Adapted from the official std::invoke proposal:
// http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2014/n4169.html

#include <type_traits>
#include <functional>

namespace scm {
namespace detail {

template <typename Functor, typename... Args>
std::enable_if_t<
    std::is_member_pointer<std::decay_t<Functor>>::value,
    std::result_of_t<Functor&&(Args&&...)>>
invoke(Functor&& f, Args&&... args)
{
    return std::mem_fn(f)(std::forward<Args>(args)...);
}

template <typename Functor, typename... Args>
std::enable_if_t<
    !std::is_member_pointer<std::decay_t<Functor>>::value,
    std::result_of_t<Functor&&(Args&&...)>>
invoke(Functor&& f, Args&&... args)
{
    return std::forward<Functor>(f)(std::forward<Args>(args)...);
}

} // namespace detail
} // namespace scm
