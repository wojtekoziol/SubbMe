//
//  NetworkService.swift
//  SubbMe
//
//  Created by Wojciech Kozioł on 21/11/2024.
//

import Foundation

struct NetworkService {
    static let shared = NetworkService()

    private init() { }

    func performRequest(_ request: NetworkRequest) async throws -> Data {
        guard let url = URL(string: request.urlString) else { throw NetworkError.invalidURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        for header in request.headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }

        urlRequest.httpBody = request.body

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        return data
    }
}
