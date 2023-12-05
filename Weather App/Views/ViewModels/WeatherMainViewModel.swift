//
//  WeatherMainViewModel.swift
//  Weather App
//
//  Created by Tim Gunnarsson on 2023-12-05.
//

import Foundation

struct City {
    let name: String
    let latitude: String
    let longitude: String
}

final class WeatherMainViewModel: ObservableObject {
    
    private let networkService: NetworkServiceProtocol
    @Published var cityWeathers: [CityWeatherViewModel] = []
    @Published var viewState: ViewState = .loading
    
    let cities: [City] = [.init(name: "Stockholm",
                                latitude: "59.3293",
                                longitude: "18.0686"),
                          .init(name: "New York",
                                latitude: "40.7128",
                                longitude: "-74.0060"),
                          .init(name: "San Francisco",
                                latitude: "37.7749",
                                longitude: "-122.4194"),
                          .init(name: "London",
                                latitude: "51.5099",
                                longitude: "-0.1180"),
                          .init(name: "Sydney",
                                latitude: "-33.8688",
                                longitude: "151.2093"),
                          .init(name: "Honululu",
                                latitude: "21.3099",
                                longitude: "-157.8581")]
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    @MainActor
    func getWeather() async {
        viewState = .loading
        do {
            try await withThrowingTaskGroup(of: CityWeatherViewModel.self) { [weak self] group in
                guard let self else { throw URLError(.unknown) }
                cities.forEach { city in
                    group.addTask {
                        
                        let weather: WeatherResponse
                        = try await                     self.networkService.perform(
                            request: .getWeather(
                                latitude: city.latitude,
                                longitude: city.longitude
                            )
                        )
                        return .init(city: city, weather: weather)
                    }
                }
                
                var weathers: [CityWeatherViewModel] = []
                for try await cityWeather in group {
                    weathers.append(cityWeather)
                }
                
                cityWeathers = weathers.sorted { $0.name < $1.name }
                viewState = .completed
            }
        } catch {
            viewState = .failure(error: error)
        }
    }
}
