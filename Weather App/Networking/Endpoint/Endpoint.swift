//
//  Hosts.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-21.
//

import Foundation

protocol Endpoint {
    typealias Host = String
    typealias Path = String
    var scheme: Scheme { get }
    var host: Host { get }
    var path: Path { get }
}

enum OpenWeatherEndpoint: Endpoint {
    
    case oneCall(path: OpenWeatherEndpoint.Paths)
    
    var scheme: Scheme {
        return .https
    }
    
    var host: Host {
        return "api.openweathermap.org"
    }
    
    var path: Path {
        switch self {
        case .oneCall(path: let path):
            return path.path
        }
    }
}

extension OpenWeatherEndpoint {
    
    enum Paths {
        case current(fields: [Field])
        case aggregate(fields: [Field])

        var path: String {
            switch self {
            case .current: return "/data/3.0/onecall"
            case .aggregate: return "/data/3.0/onecall/day_summary"
            }
        }

        enum Field {
            case lat(String)
            case lon(String)
            case appid(String = "87fbf6567da0d7492de78052f0f5723e")
            case exclude([Excluded])
            case units(Units)
            
            var key: String {
                switch self {
                case .lat:
                    "lat"
                case .lon:
                    "lon"
                case .appid:
                    "appid"
                case .exclude:
                    "exclude"
                case .units:
                    "units"
                }
            }
        }
        
        enum Units: String {
            case standard
            case metric
            case imperial
        }
        
        enum Excluded: String {
            case current
            case minutely
            case hourly
            case daily
            case alerts
        }
    }
}
