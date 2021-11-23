//
//  AppModule.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 22/11/2021.
//

import Foundation

protocol AppModule {
    var contentUseCase: ContentUseCase { get }
}

class DefaultAppModule: AppModule {
    
    // MARK: - Clients
    
    private lazy var httpClient: HTTPClient = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 10
        sessionConfiguration.timeoutIntervalForResource = 120
        let session = URLSession(configuration: sessionConfiguration)
        return HTTPClient(session, baseURL: Configurations.current.baseApiURL)
    }()
    
    // MARK: - Providers
    
    private lazy var contentsApiProvider: ContentsApiProvider = ContentsApiProviderImpl(httpClient: httpClient)
    
    // MARK: - Usecases
    private(set) lazy var contentUseCase: ContentUseCase = ContentUseCase(contentsApiProvider: contentsApiProvider)
}
