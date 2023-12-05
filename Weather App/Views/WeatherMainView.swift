//
//  ContentView.swift
//  Weather App
//
//  Created by Tim Gunnarsson on 2023-12-01.
//

import SwiftUI

struct WeatherMainView: View {
    
    @StateObject var viewModel: WeatherMainViewModel
    @Binding var navigationPaths: [NavigationPath]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.dayblue, .nightblue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            AsyncContentView(viewState: viewModel.viewState) {
                VStack {
                    Text("Weather")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)
                    ForEach(viewModel.cityWeathers) { cityWeather in
                        HStack(spacing: 10) {
                            Text(cityWeather.name)
                                .font(.title3)
                            Spacer()
                            Text(cityWeather.formattedTemperature)
                            AsyncImage(
                                url: cityWeather.currentIcon,
                                content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 25, maxHeight: 25)
                                },
                                placeholder: {
                                    EmptyView()
                                }
                            )
                        }.contentShape(Rectangle())
                        .onTapGesture {
                            navigationPaths.append(.detail(city: cityWeather))
                        }
                        .foregroundStyle(.white)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                                .shadow(color: .white, radius: 10)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.horizontal, 10)
                        }
                    }
                }
            } onRetry: {
                Task {
                    await viewModel.getWeather()
                }
            }
            .foregroundStyle(.white)
        }.task {
            await viewModel.getWeather()
        }
    }
}

#Preview {
    WeatherMainView(viewModel: .init(networkService: NetworkService()), navigationPaths: .constant([]))
}
