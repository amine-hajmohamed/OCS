//
//  ContentsApiProviderImplTests.swift
//  OCSTests
//
//  Created by Mohamed Amine HAJ MOHAMED on 21/11/2021.
//
// swiftlint:disable implicitly_unwrapped_optional

import XCTest
import Combine
@testable import OCS

class ContentsApiProviderImplTests: XCTestCase {
    
    private var sut: ContentsApiProviderImpl!
    private var subscriptions: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: sessionConfiguration)
        let httpClient = HTTPClient(session, baseUrl: "")
        sut = ContentsApiProviderImpl(httpClient: httpClient)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        subscriptions = []
        sut = nil
    }
    
    func test_searchContents() {
        let receiveCompletionExpectation = XCTestExpectation()
        let receiveValueExpectation = XCTestExpectation()
        
        // when
        sut.searchContents(title: "Game")
            .sink(receiveCompletion: { completion in
                // then
                if case .finished = completion {
                } else {
                    XCTAssert(false, "Did not succeeded -> receiveCompletion: \(completion)")
                }
                receiveCompletionExpectation.fulfill()
            }, receiveValue: { contents in
                // then
                XCTAssertEqual(contents.count, 147)
                
                let firstContent = contents.first
                XCTAssertEqual(firstContent?.title, "GAME OF THRONES")
                XCTAssertEqual(firstContent?.subTitle, "saisons 1 à 8")
                XCTAssertEqual(firstContent?.imageURL,
                               "/data_plateforme/saison/1691/origin_gameofthr08w0149292_ni72q.jpg?size=small")
                
                receiveValueExpectation.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [receiveCompletionExpectation, receiveValueExpectation], timeout: 5)
    }
}

// MARK: - URLProtocolStub
private class URLProtocolStub: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let fileUrl = Bundle(for: URLProtocolStub.self)
                .url(forResource: "contents_search_title_Game", withExtension: "json"),
              let data = try? Data(contentsOf: fileUrl) else {
                  client?.urlProtocolDidFinishLoading(self)
                  return
              }
        
        if let response = HTTPURLResponse(url: fileUrl, statusCode: 200, httpVersion: nil, headerFields: nil) {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
