#include "bitarray.hpp"

std::size_t bit_mask(const std::size_t bit_index) noexcept {
  return 1U << (bit_index % 8U);
}

namespace data_structures {
Bitarray::Bitarray(std::size_t size)
    : m_size{ size }, m_data{ new uint8_t[(size + 7) / 8] } {}

Bitarray::Bitarray(std::initializer_list<std::uint8_t> values)
    : m_size{ 1 }, m_data{ new uint8_t[1] } {
  for (const auto& value : values) {
    std::cout << value << std::endl;
  }
}

// NOLINTNEXTLINE
Bitarray::Bitarray(Bitarray&& bitarray) noexcept : m_data{} {
  swap(*this, bitarray);
}

Bitarray::~Bitarray() { delete[] m_data; }

Bitarray& data_structures::Bitarray::operator=(Bitarray&& bitarray) noexcept {
  swap(*this, bitarray);
  return *this;
}

bool Bitarray::operator[](const std::size_t index) const noexcept {
  assert(index < this->m_size);
  return static_cast<bool>(this->m_data[index >> 3U] & bit_mask(index));
}

void swap(Bitarray& left, Bitarray& right) noexcept {
  std::swap(left.m_size, right.m_size);
  std::swap(left.m_data, right.m_data);
}
}  // namespace data_structures

std::ostream& operator<<(std::ostream& out,
                         const data_structures::Bitarray& bitarray) {
  for (std::size_t i{}; i < bitarray.size(); ++i) {
    if (i % 8 == 0 && i > 0) {
      out << "_";
    }
    out << bitarray[i];
  }

  return out;
}
