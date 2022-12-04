#include "bitarray.hpp"

void data_structures::swap(data_structures::bitarray& left,
                           data_structures::bitarray& right) noexcept {
  std::swap(left.m_size, right.m_size);
  std::swap(left.m_data, right.m_data);
}

data_structures::bitarray::bitarray(std::size_t size)
    : m_size{ size }, m_data{ new uint8_t[(size + 7) / 8] } {}

// NOLINTNEXTLINE(*member-init)
data_structures::bitarray::bitarray(bitarray&& bitarray) noexcept {
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
  return static_cast<bool>(this->m_data[index / 8] & bit::mask(index));
}
