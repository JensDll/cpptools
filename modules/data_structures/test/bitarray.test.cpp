#include "bitarray.hpp"

#include <catch2/catch_test_macros.hpp>

TEST_CASE("Single size constructor") {
  data_structures::bitarray bitarray{ 10 };
  REQUIRE(bitarray.size() == 10);
}

TEST_CASE("Move assignment") {
  data_structures::bitarray bitarray_a{ 10 };
  data_structures::bitarray bitarray_b{ 20 };
  REQUIRE(bitarray_a.size() == 10);
  REQUIRE(bitarray_b.size() == 20);
  bitarray_a = std::move(bitarray_b);
  REQUIRE(bitarray_a.size() == 20);
}
