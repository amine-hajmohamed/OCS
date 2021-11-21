//
//  HTTPClient.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 19/11/2021.
//

import Foundation
import Combine

class HTTPClient {
    
    // MARK: - Properties
    
    private let session: URLSession
    private let baseUrl: String
    
    // MARK: - Initializer
    
    init(_ session: URLSession, baseUrl: String) {
        self.session = session
        self.baseUrl = baseUrl
    }
    
    // MARK: - Functions
    
    func request(path: String,
                 method: HTTPMethod = .get) -> AnyPublisher<(data: Data, response: HTTPURLResponse), Error> {
        guard let url = URL(string: baseUrl + path) else {
            return Fail(error: HTTPClientError.malformedURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return session.dataTaskPublisher(for: request)
            .compactMap { data, response in
                guard let response = response as? HTTPURLResponse else {
                    return nil
                }

                return (data, response)
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

// MARK: - HTTPMethod

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

// MARK: - HTTPClientError

enum HTTPClientError: Error {
    case malformedURL
}
