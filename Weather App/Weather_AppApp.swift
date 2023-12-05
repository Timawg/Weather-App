//
//  Weather_AppApp.swift
//  Weather App
//
//  Created by Tim Gunnarsson on 2023-12-01.
//

import SwiftUI

enum NavigationPath: Hashable {
    case main
    case detail(city: CityWeatherViewModel)
}

@main
struct Weather_AppApp: App {
    
    private let networkService = NetworkService()
    @State private var navigationPaths = [NavigationPath]()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPaths) {
                WeatherMainView(viewModel: .init(networkService: networkService), navigationPaths: $navigationPaths)
                    .navigationDestination(for: NavigationPath.self) { path in
                        switch path {
                        case .detail(city: let viewModel):
                            CityWeatherView(viewModel: viewModel)
                        case .main:
                            WeatherMainView(viewModel: .init(networkService: networkService), navigationPaths: $navigationPaths)
                        }
                    }
            }
        }
    }
}
