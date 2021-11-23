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
    private let baseURL: String
    
    // MARK: - Initializer
    
    init(_ session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    // MARK: - Functions
    
    func request(path: String,
                 method: HTTPMethod = .get,
                 parameters: [String: String]? = nil) -> AnyPublisher<(data: Data, response: HTTPURLResponse), Error> {
        
        var urlComponents = URLComponents(string: baseURL + path)
        urlComponents?.queryItems = parameters?.map { URLQueryItem(name: $0, value: $1) }
        
        guard let url = urlComponents?.url else {
            return Fail(error: HTTPClientError.malformedURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        parameters?.forEach { request.allHTTPHeaderFields?[$0] = $1 }
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
