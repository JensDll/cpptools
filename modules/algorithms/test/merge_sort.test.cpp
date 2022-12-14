#include "merge_sort.hpp"

#include <catch2/catch_test_macros.hpp>
#include <catch2/generators/catch_generators_all.hpp>
#include <catch2/matchers/catch_matchers_vector.hpp>

#include <array>
#include <iostream>
#include <list>

SCENARIO("merge sort") {
  GIVEN("int array") {
    std::array<int, 6> array{ 6, 5, 4, 3, 2, 1 };
    std::array<int, 6> other_array{ array };

    WHEN("using merge_sort") {
      int num_implications{ algorithms::merge_sort(array.begin(),
                                                   array.end()) };

      THEN("the array is sorted") {
        std::sort(other_array.begin(), other_array.end());
        REQUIRE(array == other_array);
      }

      THEN("the counted number of implications are correct") {
        REQUIRE(num_implications == 15);
      }
    }
  }

  GIVEN("double array") {
    std::array<double, 6> array{ 6, 5, 4, 3, 2, 1 };
    std::array<double, 6> other_array{ array };

    WHEN("using merge_sort") {
      int num_implications{ algorithms::merge_sort(array.begin(),
                                                   array.end()) };

      THEN("the array is sorted") {
        std::sort(other_array.begin(), other_array.end());
        REQUIRE(array == other_array);
      }

      THEN("the counted number of implications are correct") {
        REQUIRE(num_implications == 15);
      }
    }
  }

  GIVEN("random vector data") {
    auto vector = GENERATE(take(100, chunk(100, random(-1000, 1000))));
    auto other_vector{ vector };

    WHEN("using merge_sort") {
      algorithms::merge_sort(vector.begin(), vector.end());

      THEN("the vector is sorted") {
        std::sort(other_vector.begin(), other_vector.end());
        REQUIRE_THAT(vector, Catch::Matchers::Equals(other_vector));
      }
    }
  }
}
