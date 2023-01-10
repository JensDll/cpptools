#include "bitarray.hpp"

#include <catch2/catch_test_macros.hpp>
#include <catch2/generators/catch_generators_all.hpp>

#include <array>

SCENARIO("bitarray can be constructed") {
  GIVEN("random sizes") {
    auto size{ static_cast<std::size_t>(GENERATE(take(20, random(42, 420)))) };

    WHEN("constructed") {
      data_structures::Bitarray bits(size);

      THEN("the size is correct") { REQUIRE(bits.size() == size); }
    }
  }
}

SCENARIO("bitarray can be moved") {
  GIVEN("given some bitarray") {
    data_structures::Bitarray bits(42);

    THEN("test the initial state") { REQUIRE(bits.size() == 42); }

    WHEN("move constructed") {
      auto bits_moved{ std::move(bits) };

      THEN("the size is correct") { REQUIRE(bits_moved.size() == 42); }
    }

    WHEN("move assigned") {
      auto bits_moved = std::move(bits);

      THEN("the size is correct") { REQUIRE(bits_moved.size() == 42); }
    }

    WHEN("move initialized") {
      auto bits_moved{ std::move(bits) };

      THEN("the size is correct") { REQUIRE(bits_moved.size() == 42); }
    }
  }
}
