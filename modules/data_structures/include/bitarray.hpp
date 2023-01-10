#ifndef CPPTOOLS_DATA_STRUCTURES_BITARRAY_HPP
#define CPPTOOLS_DATA_STRUCTURES_BITARRAY_HPP

#include <cassert>
#include <cstddef>
#include <iostream>

namespace data_structures {
#ifdef IS_WINDOWS
class __declspec(dllexport) bitarray {
#else
class Bitarray {
#endif
 private:
  std::size_t m_size;
  std::uint8_t* m_data;

 public:
  Bitarray() = delete;
  explicit Bitarray(std::size_t size);
  explicit Bitarray(std::initializer_list<std::uint8_t> values);
  Bitarray(const Bitarray& bitarray) = delete;
  Bitarray(Bitarray&& bitarray) noexcept;
  ~Bitarray();

  [[nodiscard]] std::size_t size() const noexcept { return m_size; };

  Bitarray& operator=(const Bitarray& bitarray) = delete;
  Bitarray& operator=(Bitarray&& bitarray) noexcept;
  bool operator[](const std::size_t index) const noexcept;

  friend void swap(Bitarray& left, Bitarray& right) noexcept;
};

void swap(Bitarray& left, Bitarray& right) noexcept;

}  // namespace data_structures

std::ostream& operator<<(std::ostream& out,
                         const data_structures::Bitarray& bitarray);

#endif
