// Swift sample for syntax highlighting
import Foundation

/// A measurement that can be formatted for display.
protocol Describable {
    var summary: String { get }
}

enum Temperature: Equatable {
    case celsius(Double)
    case fahrenheit(Double)

    var inCelsius: Double {
        switch self {
        case let .celsius(value):
            return value
        case let .fahrenheit(value):
            return (value - 32) * 5 / 9
        }
    }
}

struct WeatherReading: Describable {
    let city: String
    let temperature: Temperature
    var humidity: Double = 0.5

    var summary: String {
        String(format: "%@: %.1f C", city, temperature.inCelsius)
    }
}

extension Array where Element: Describable {
    func summaries() -> [String] {
        map { $0.summary }
    }
}

let readings = [
    WeatherReading(city: "Oslo", temperature: .celsius(-3.0)),
    WeatherReading(city: "Phoenix", temperature: .fahrenheit(104.0), humidity: 0.1),
]

let warmest = readings.max { lhs, rhs in
    lhs.temperature.inCelsius < rhs.temperature.inCelsius
}

if let warmest {
    print("Warmest: \(warmest.summary)")
}

for line in readings.summaries() {
    print(line)
}
