#ifndef CPPTOOLS_ALGORITHMS_MERGE_SORT_HPP
#define CPPTOOLS_ALGORITHMS_MERGE_SORT_HPP

#include <array>
#include <cassert>
#include <iostream>

namespace algorithms {
template <std::random_access_iterator iter>
int merge_sort(iter start, iter end);
}  // namespace algorithms

template <std::random_access_iterator iter>
using difference_type = typename std::iterator_traits<iter>::difference_type;

template <std::random_access_iterator iter>
using value_type = typename std::iterator_traits<iter>::value_type;

template <std::random_access_iterator iter>
inline difference_type<iter> merge(iter destination, iter left,
                                   difference_type<iter> left_length,
                                   iter right,
                                   difference_type<iter> right_length) {
  difference_type<iter> num_inversions{};

  while (left_length > 0 && right_length > 0) {
    if (*left <= *right) {
      *destination++ = *left++;
      --left_length;
    } else {
      num_inversions += left_length;
      *destination++ = *right++;
      --right_length;
    }
  }

  while (left_length > 0) {
    *destination++ = *left++;
    --left_length;
  }

  while (right_length > 0) {
    *destination++ = *right++;
    --right_length;
  }

  return num_inversions;
}

template <std::random_access_iterator iter>
inline void merge_sort_impl(const iter destination, const iter source,
                            const difference_type<iter> length,
                            difference_type<iter>* const num_inversions) {
  switch (length) {
    case 1:
      destination[0] = source[0];
      return;
    case 2:
      if (source[0] <= source[1]) {
        destination[0] = source[0];
        destination[1] = source[1];
      } else {
        destination[0] = source[1];
        destination[1] = source[0];
        ++*num_inversions;
      }
      return;
  }

  auto* const copy{ new value_type<iter>[static_cast<std::size_t>(length)] };

  const difference_type<iter> left_length{ length / 2 };
  const difference_type<iter> right_length{ length - left_length };

  merge_sort_impl(static_cast<iter>(copy), source, left_length, num_inversions);
  merge_sort_impl(static_cast<iter>(copy + left_length), source + left_length,
                  right_length, num_inversions);

  *num_inversions += merge(destination, static_cast<iter>(copy), left_length,
                           static_cast<iter>(copy + left_length), right_length);

  delete[] copy;
}

template <std::random_access_iterator iter>
int algorithms::merge_sort(const iter start, const iter end) {
  difference_type<iter> num_inversions{};

  const difference_type<iter> distance{ end - start };
  assert(distance > 0);
  merge_sort_impl(start, start, distance, &num_inversions);

  return static_cast<int>(num_inversions);
}
#endif
