// C++ sample for syntax highlighting
#include <algorithm>
#include <iostream>
#include <memory>
#include <string>
#include <vector>

namespace galewind {

inline constexpr double kEpsilon = 1e-9;

template <typename T>
class Stack {
public:
    void push(T value) { data_.push_back(std::move(value)); }

    [[nodiscard]] bool empty() const noexcept { return data_.empty(); }

    std::optional<T> pop() {
        if (data_.empty()) {
            return std::nullopt;
        }
        T value = std::move(data_.back());
        data_.pop_back();
        return value;
    }

private:
    std::vector<T> data_{};
};

struct Point {
    double x{0.0};
    double y{0.0};

    double magnitude() const { return std::hypot(x, y); }
};

}  // namespace galewind

int main() {
    using galewind::Point;
    using galewind::Stack;

    Stack<Point> stack;
    stack.push(Point{3.0, 4.0});
    stack.push(Point{6.0, 8.0});

    std::vector<double> sizes;
    while (auto point = stack.pop()) {
        sizes.push_back(point->magnitude());
    }

    std::sort(sizes.begin(), sizes.end(), [](double a, double b) { return a > b; });
    for (const auto& size : sizes) {
        std::cout << "magnitude = " << size << '\n';
    }
    return 0;
}
