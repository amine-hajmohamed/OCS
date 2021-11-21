//
//  HTTPClientTests.swift
//  OCSTests
//
//  Created by Mohamed Amine HAJ MOHAMED on 19/11/2021.
//
// swiftlint:disable implicitly_unwrapped_optional

import XCTest
import Combine
@testable import OCS

private let kResponseDataUrlKey = "url"
private let kResponseDataMethodKey = "method"

class HTTPClientTests: XCTestCase {
    
    private var sut: HTTPClient!
    private var subscriptions: Set<AnyCancellable> = []
    
    private let baseUrl = "baseUrl"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: sessionConfiguration)
        
        sut = HTTPClient(session, baseUrl: baseUrl)
    }
    
    override func tearDownWithError() throws {
        subscriptions = []
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_request_get() throws {
        let receiveValueExpectation = XCTestExpectation()
        let receiveCompletionExpectation = XCTestExpectation()
        
        // given
        let path = "/path"
        let fullUrl = baseUrl + path
        
        // when
        sut.request(path: path)
            .sink(receiveCompletion: { completion in
                // then
                if case .finished = completion {
                } else {
                    XCTAssert(false, "Did not fail -> receiveCompletion: \(completion)")
                }
                
                receiveCompletionExpectation.fulfill()
            }, receiveValue: { data, response in
                // then
                XCTAssertEqual(response.url?.absoluteString, fullUrl)
                
                if let data = try? JSONDecoder().decode([String: String].self, from: data) {
                    XCTAssertEqual(data[kResponseDataUrlKey], fullUrl)
                    XCTAssertEqual(data[kResponseDataMethodKey]?.uppercased(), "GET")
                } else {
                    XCTAssert(false, "Could not decode data using JSONDecoder")
                }
                
                receiveValueExpectation.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [receiveValueExpectation, receiveCompletionExpectation], timeout: 5)
    }
    
    func test_request_get_with_malformed_URL() {
        let receiveCompletionExpectation = XCTestExpectation()
        
        // given
        let path = "// p - ?"
        
        // when
        sut.request(path: path)
            .sink(receiveCompletion: { completion in
                // then
                if case .failure(let error) = completion {
                    XCTAssertEqual(error as? HTTPClientError, HTTPClientError.malformedURL)
                } else {
                    XCTAssert(false, "Did not fail -> receiveCompletion: \(completion)")
                }
                
                receiveCompletionExpectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &subscriptions)
        
        wait(for: [receiveCompletionExpectation], timeout: 5)
    }
}

// MARK: - URLProtocolMock

private class URLProtocolMock: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: HTTPClientError.malformedURL)
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        var responseData = [kResponseDataUrlKey: url.absoluteString]
        
        if let method = request.httpMethod {
            responseData[kResponseDataMethodKey] = method
        }
        
        if let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let data = try? JSONEncoder().encode(responseData) {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
}
