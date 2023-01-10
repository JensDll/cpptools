#include "bitarray.hpp"

data_structures::bitarray::bitarray(std::size_t size)
    : m_size{ size }, m_data{ new uint8_t[(size + 7) / 8] } {}

data_structures::bitarray::bitarray(std::initializer_list<std::uint8_t> values)
    : m_size{ 1 }, m_data{ new uint8_t[1] } {
  for (const auto& value : values) {
    std::cout << value << std::endl;
  }
}

// NOLINTNEXTLINE
data_structures::bitarray::bitarray(bitarray&& bitarray) noexcept : m_data{} {
  swap(*this, bitarray);
}

data_structures::bitarray::~bitarray() { delete[] m_data; }

data_structures::bitarray& data_structures::bitarray::operator=(
    bitarray&& bitarray) noexcept {
  swap(*this, bitarray);
  return *this;
}

bool data_structures::bitarray::operator[](
    const std::size_t index) const noexcept {
  assert(index < this->m_size);
  return static_cast<bool>(this->m_data[index >> 3U] & bit::mask(index));
}

void data_structures::swap(data_structures::bitarray& left,
                           data_structures::bitarray& right) noexcept {
  std::swap(left.m_size, right.m_size);
  std::swap(left.m_data, right.m_data);
}

std::ostream& operator<<(std::ostream& out,
                         const data_structures::bitarray& bitarray) {
  for (std::size_t i{}; i < bitarray.size(); ++i) {
    if (i % 8 == 0 && i > 0) {
      out << "_";
    }
    out << bitarray[i];
  }

  return out;
}
