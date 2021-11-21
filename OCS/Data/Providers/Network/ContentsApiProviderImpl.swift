//
//  ContentsApiProviderImpl.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 19/11/2021.
//

import Foundation
import Combine

class ContentsApiProviderImpl: ContentsApiProvider {
    
    // MARK: - Properties
    
    private let httpClient: HTTPClient
    
    // MARK: - Initializer
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    // MARK: - Functions
    
    func searchContents(title: String) -> AnyPublisher<[Content], Error> {
        httpClient.request(path: "https://api.ocs.fr/apps/v2/contents?search=title")
            .map { $0.data }
            .decode(type: ContentSearchResultNTDto.self, decoder: JSONDecoder())
            .map { ( $0.contents ?? [] ).compactMap { $0.toEntity() } }
            .eraseToAnyPublisher()
    }
}
