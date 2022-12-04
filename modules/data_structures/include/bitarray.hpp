#ifndef JENSDLL_DATA_STRUCTURES_BITARRAY_HPP
#define JENSDLL_DATA_STRUCTURES_BITARRAY_HPP

#include "bit.hpp"

#include <cstddef>

namespace data_structures {
#ifdef IS_WINDOWS
class __declspec(dllexport) bitarray {
#else
class bitarray {
#endif
 private:
  std::size_t m_size;
  uint8_t* m_data;

 public:
  bitarray() = delete;
  explicit bitarray(std::size_t size);
  bitarray(const bitarray& bitarray) = delete;
  bitarray(bitarray&& bitarray) noexcept;
  ~bitarray();

  [[nodiscard]] std::size_t size() const noexcept { return m_size; };

  bitarray& operator=(const bitarray& bitarray) = delete;
  bitarray& operator=(bitarray&& bitarray) noexcept;
  bool operator[](const std::size_t index) const noexcept;

  friend void swap(bitarray& left, bitarray& right) noexcept;
};

}  // namespace data_structures

#endif
