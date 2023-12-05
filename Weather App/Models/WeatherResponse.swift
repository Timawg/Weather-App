// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct WeatherResponse: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: TimeInterval
    let current: Current
    let hourly: [Current]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly
    }
}

// MARK: - Current
struct Current: Codable, Identifiable {
    
    var id: String {
        UUID().uuidString
    }

    let dt: TimeInterval
    let sunrise, sunset: TimeInterval?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds: Int
    let visibility: Int?
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let windGust, pop: Double?
    let snow: Snow?
    
    var formattedHumidity: String {
        return String(format: "%i", humidity) + "%"
    }
    
    var formattedWindSpeed: String {
        let measurement = Measurement(value: windSpeed, unit: UnitSpeed.metersPerSecond)
        let formatter = MeasurementFormatter()
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter = numberFormatter
        return formatter.string(from: measurement)
    }

    func formattedDate(for timezone: String) -> String {
        let unixTime = dt
        let date = Date(timeIntervalSince1970: unixTime)
        let timezone = TimeZone(identifier: timezone) ?? .current
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = timezone
        return dateFormatter.string(from: date)
    }

    func formattedHour(for timezone: String) -> String {
        let unixTime = dt
        let date = Date(timeIntervalSince1970: unixTime)
        let timezone = TimeZone(identifier: timezone) ?? .current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.timeZone = timezone
        return dateFormatter.string(from: date)
    }
    
    var formattedTemperature: String {
        let measurement = Measurement(value: temp.rounded(.toNearestOrAwayFromZero), unit: UnitTemperature.kelvin)
        let formatter = MeasurementFormatter()
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter = numberFormatter
        return formatter.string(from: measurement)
    }

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case windGust = "wind_gust"
        case pop, snow
    }
}

// MARK: - Snow
struct Snow: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Weather
struct Weather: Codable, Identifiable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    var iconURL: URL? {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(icon).png") else {
            return nil
        }
        return url
    }
}
