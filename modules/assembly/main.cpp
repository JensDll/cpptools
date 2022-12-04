#include "bitarray.hpp"

#include <iostream>
#include <vector>

extern "C" {
int fibonacci(int n);
int compile_explorer(int n);
void some_function();
}

int main() {
  std::vector<int> vec{ 1, 2, 3 };
  std::size_t vec_size{ vec.size() };

  data_structures::bitarray bitarray{};

  std::cout << vec_size << " " << bitarray.size() << std::endl;
}
