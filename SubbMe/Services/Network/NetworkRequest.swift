//
//  NetworkRequest.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 22/11/2024.
//

import Foundation

struct NetworkRequest {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    let apiBaseUrl = "http://localhost:8080/"
    let endpoint: String
    let method: HTTPMethod
    let token: String?
    let body: Data?

    var urlString: String {
        apiBaseUrl + endpoint
    }

    var headers: [String: String] {
        var headers: [String: String] = [:]
        if let token {
            headers["Authorization"] = "Bearer \(token)"
        }
        if body != nil {
            headers["Content-Type"] = "application/json"
        }
        return headers
    }
}
