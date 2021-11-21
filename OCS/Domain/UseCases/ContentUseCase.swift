//
//  ContentUseCase.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 19/11/2021.
//

import Combine

class ContentUseCase {
    
    // MARK: - Providers
    
    private let contentsApiProvider: ContentsApiProvider
    
    // MARK: - Initializer
    
    init(contentsApiProvider: ContentsApiProvider) {
        self.contentsApiProvider = contentsApiProvider
    }
    
    // MARK: - UseCases
    
    func searchContents(_ title: String) -> AnyPublisher<[Content], Error> {
        contentsApiProvider.searchContents(title: title)
    }
}
