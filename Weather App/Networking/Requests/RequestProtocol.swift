//
//  RequestProtocol.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-06.
//

import Foundation

protocol RequestProtocol {
    var endpoint: Endpoint { get }
    var httpMethod: HTTPMethod { get }
    var url: URL? { get }
    func request() throws -> URLRequest
}
