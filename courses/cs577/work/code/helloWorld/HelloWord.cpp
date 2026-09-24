#include <iostream>
#include <string>

int main() {
    int num;
    std::cin >> num;

    std::string name;
    std::getline(std::cin, name); // Consume the rest of the number's line

    for (int i = 0; i < num; i++) {
        std::getline(std::cin, name);
        std::cout << "Hello, " << name << "!" << std::endl;
    }

    return 0;
}
