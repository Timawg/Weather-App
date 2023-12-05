//
//  PostsRequest.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-06.
//

import Foundation

struct GetWeatherRequest: RequestProtocol {
    let endpoint: Endpoint
    let httpMethod: HTTPMethod = .GET
    let url: URL?
    
    init(path: OpenWeatherEndpoint.Paths) {
        self.endpoint = OpenWeatherEndpoint.oneCall(path: path)
        self.url = DefaultURLFactory.createURL(from: endpoint)
    }

    func request() throws -> URLRequest {
        guard let url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
    }
}

extension RequestProtocol where Self == GetWeatherRequest {
    
    static func getWeather(latitude: String, longitude: String) -> RequestProtocol {
        GetWeatherRequest(path: .current(fields: [.lat(latitude),
                                                  .lon(longitude),
                                                  .exclude([.alerts, .daily, .minutely]),
                                                  .appid()]))
    }
}
