#include "bit.hpp"

std::size_t bit::mask(const std::size_t bit_index) noexcept {
  return 1U << (bit_index % 8U);
}
