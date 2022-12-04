#ifndef JENSDLL_DATA_STRUCTURES_BITARRAY_HPP
#define JENSDLL_DATA_STRUCTURES_BITARRAY_HPP

#include <iostream>

namespace data_structures {
#ifdef IS_WINDOWS
class __declspec(dllexport) bitarray {
#else
class bitarray {
#endif
 private:
  std::size_t m_size{};

 public:
  bitarray() = default;

  std::size_t size() const noexcept { return m_size; };

  bool operator[](std::size_t index) const noexcept {
    std::cout << index << std::endl;
    return false;
  };

  void rotate() noexcept;
};
}  // namespace data_structures
#endif
