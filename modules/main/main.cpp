#include <iostream>

extern "C" {
int some_function();
}

int main() {
  int result = some_function();

  std::cout << "The result is: " << result << std::endl;

  return 0;
}
