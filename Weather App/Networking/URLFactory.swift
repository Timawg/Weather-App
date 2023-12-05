//
//  URLFactory.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-23.
//

import Foundation

protocol URLFactory {
    static func createURL(from endpoint: Endpoint) -> URL?
}

struct DefaultURLFactory: URLFactory {
    
    static func createURL(from endpoint: Endpoint) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme.rawValue
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        switch endpoint as? OpenWeatherEndpoint {
        case .oneCall(path: let path):
            switch path {
            case .current(fields: let fields):
                
                var queryItems = [URLQueryItem]()
                fields.forEach { field in
                    switch field {
                    case .lat(let latitude):
                        queryItems.append(.init(name: field.key, value: latitude))
                    case .lon(let longitude):
                        queryItems.append(.init(name: field.key, value: longitude))
                    case .appid(let id):
                        queryItems.append(.init(name: field.key, value: id))
                    case .exclude(let excluded):
                        let excluded = excluded.map { $0.rawValue }.joined(separator: ",")
                            queryItems.append(.init(name: field.key, value: excluded))
                    case .units(let units):
                        queryItems.append(.init(name: field.key, value: units.rawValue))
                    }
                }
                
                urlComponents.queryItems = queryItems

            default: break
            }
        case .none:
            break
        }

        return urlComponents.url
    }
}
