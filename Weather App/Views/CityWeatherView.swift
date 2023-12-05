//
//  CityWeatherView.swift
//  Weather App
//
//  Created by Tim Gunnarsson on 2023-12-01.
//

import SwiftUI

struct CityWeatherView: View {
    
    @State var viewModel: CityWeatherViewModel
    
    var body: some View {
        ZStack {
            Image(viewModel.backgroundImageName)
                .resizable()
                .padding(.all, -15)
                .ignoresSafeArea()
                .blur(radius: 10)
            ScrollView {
            VStack(spacing: 10) {
                Text(viewModel.name)
                    .font(.largeTitle)
                Text(viewModel.formattedTemperature)
                    .font(.largeTitle)
                if let description = viewModel.currentDescription {
                    Text(description)
                        .font(.title3)
                }
                Text(viewModel.formattedDate)
                    .font(.caption)
                WeatherForecastView(viewModel: $viewModel)
                HStack {
                    VStack {
                        Text("WIND SPEED")
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 1)
                            .shadow(color: .black, radius: 10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .padding(.horizontal, 20)
                            .blur(radius: 2).overlay {
                                Text(viewModel.weather.current.formattedWindSpeed)
                                    .font(.title)
                                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            }
                    }
                    VStack {
                        Text("HUMIDITY")
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 1)
                            .shadow(color: .black, radius: 10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .padding(.horizontal, 20)
                            .blur(radius: 2).overlay {
                                Text(viewModel.weather.current.formattedHumidity)
                                    .font(.title)
                                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            }
                    }
                }
                .frame(minHeight: 150)
                .padding(.top, 15)
            }
        }
        }
        .foregroundStyle(.white)
    }
}

struct WeatherForecastView: View {
    
    @Binding var viewModel: CityWeatherViewModel
    
    var body: some View {
        Text("Hourly forecast for today and tomorrow")
            .multilineTextAlignment(.center)
            .padding(.top)
        HStack {
            ScrollView(.horizontal) {
                HStack(spacing: 15) {
                    ForEach(viewModel.weather.hourly) { weather in
                        VStack(spacing: 15) {
                            Text(weather.formattedHour(for: viewModel.weather.timezone))
                            AsyncImage(
                                url: weather.weather.first?.iconURL,
                                content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 25, maxHeight: 25)
                                },
                                placeholder: {
                                    EmptyView()
                                }
                            )
                            Text(String(weather.formattedTemperature))
                        }
                        Divider()
                    }
                }
            }.scrollIndicators(.hidden)
                .frame(maxWidth: .infinity, minHeight: 150)
                .padding(.horizontal, 25)
                .foregroundStyle(.white)
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white, lineWidth: 1)
                        .shadow(color: .black, radius: 10)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(.horizontal, 20)
                        .blur(radius: 2)
                }
        }
    }
}

#Preview {
    let mockedWeatherResponse = WeatherResponse(
        lat: 37.7749,
        lon: -122.4194,
        timezone: "America/Los_Angeles",
        timezoneOffset: -28800,
        current: Current(
            dt: Date().timeIntervalSince1970,
            sunrise: Date().addingTimeInterval(3600).timeIntervalSince1970,
            sunset: Date().addingTimeInterval(7200).timeIntervalSince1970,
            temp: 25.0,
            feelsLike: 26.5,
            pressure: 1015,
            humidity: 70,
            dewPoint: 18.5,
            uvi: 5.0,
            clouds: 20,
            visibility: 10000,
            windSpeed: 5.0,
            windDeg: 180,
            weather: [
                Weather(id: 801, main: "Clouds", description: "Few clouds", icon: "02d")
            ],
            windGust: 7.0,
            pop: 0.2,
            snow: Snow(the1H: 0.0)
        ),
        hourly: [
            Current(
                dt: Date().timeIntervalSince1970,
                sunrise: Date().addingTimeInterval(3600).timeIntervalSince1970,
                sunset: Date().addingTimeInterval(7200).timeIntervalSince1970,
                temp: 25.0,
                feelsLike: 26.5,
                pressure: 1015,
                humidity: 70,
                dewPoint: 18.5,
                uvi: 5.0,
                clouds: 20,
                visibility: 10000,
                windSpeed: 5.0,
                windDeg: 180,
                weather: [
                    Weather(id: 801, main: "Clouds", description: "Few clouds", icon: "02d")
                ],
                windGust: 7.0,
                pop: 0.2,
                snow: Snow(the1H: 0.0)
            ),
            Current(
                dt: Date().timeIntervalSince1970,
                sunrise: Date().addingTimeInterval(3600).timeIntervalSince1970,
                sunset: Date().addingTimeInterval(7200).timeIntervalSince1970,
                temp: 25.0,
                feelsLike: 26.5,
                pressure: 1015,
                humidity: 70,
                dewPoint: 18.5,
                uvi: 5.0,
                clouds: 20,
                visibility: 10000,
                windSpeed: 5.0,
                windDeg: 180,
                weather: [
                    Weather(id: 801, main: "Clouds", description: "Few clouds", icon: "02d")
                ],
                windGust: 7.0,
                pop: 0.2,
                snow: Snow(the1H: 0.0)
            )
        ]
    )
    return CityWeatherView(viewModel: .init(city: .init(name: "New York", latitude: "", longitude: ""), weather: mockedWeatherResponse))
}
