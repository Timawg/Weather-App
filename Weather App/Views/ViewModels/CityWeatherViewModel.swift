//
//  CityWeatherViewModel.swift
//  Weather App
//
//  Created by Tim Gunnarsson on 2023-12-05.
//

import Foundation

struct CityWeatherViewModel: Identifiable, Hashable {

    var id: String {
        UUID().uuidString
    }

    let city: City
    let weather: WeatherResponse
    
    var name: String {
        city.name
    }
    
    var backgroundImageName: String {
        if weather.current.clouds < 25 {
            let current = Date(timeIntervalSince1970: weather.current.dt)
            let sunrise = Date(timeIntervalSince1970: weather.current.sunrise ?? 0)
            let sunset = Date(timeIntervalSince1970: weather.current.sunset ?? 0)
            if current > sunrise && current < sunset {
                return "sunny"
            } else {
                return "night"
            }
        } else {
            return "clouds"
        }
    }
    
    var formattedDate: String {
        weather.current.formattedDate(for: weather.timezone)
    }
    
    var formattedTemperature: String {
        weather.current.formattedTemperature
    }
    
    var currentIcon: URL? {
        return weather.current.weather.first?.iconURL
    }
    
    var currentDescription: String? {
        weather.current.weather.first?.description.capitalized
    }
    
    static func == (lhs: CityWeatherViewModel, rhs: CityWeatherViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
