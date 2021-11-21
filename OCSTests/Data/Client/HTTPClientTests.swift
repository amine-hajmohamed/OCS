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
private let kResponseDataParametersKey = "parameters"

class HTTPClientTests: XCTestCase {
    
    private var sut: HTTPClient!
    private var subscriptions: Set<AnyCancellable> = []
    
    private let baseUrl = "baseUrl"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: sessionConfiguration)
        
        sut = HTTPClient(session, baseUrl: baseUrl)
    }
    
    override func tearDownWithError() throws {
        subscriptions = []
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_request_methodDefaultGet_and_path() {
        let receiveCompletionExpectation = XCTestExpectation()
        let receiveValueExpectation = XCTestExpectation()
        
        // given
        let path = "/path"
        let fullUrl = baseUrl + path
        
        // when
        sut.request(path: path)
            .sink(receiveCompletion: { completion in
                // then
                if case .finished = completion {
                } else {
                    XCTAssert(false, "Did not succeeded -> receiveCompletion: \(completion)")
                }
                
                receiveCompletionExpectation.fulfill()
            }, receiveValue: { data, response in
                // then
                XCTAssertEqual(response.url?.absoluteString, fullUrl)
                
                if let data = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    XCTAssertEqual(data[kResponseDataUrlKey] as? String, fullUrl)
                    XCTAssertEqual((data[kResponseDataMethodKey] as? String)?.uppercased(), "GET")
                } else {
                    XCTAssert(false, "Could not decode data")
                }
                
                receiveValueExpectation.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [receiveCompletionExpectation, receiveValueExpectation], timeout: 5)
    }
    
    func test_request_malformedURL() {
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
                    XCTAssert(false, "Did not failed -> receiveCompletion: \(completion)")
                }
                
                receiveCompletionExpectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &subscriptions)
        
        wait(for: [receiveCompletionExpectation], timeout: 5)
    }
    
    func test_request_methodPost_and_parameters_and_path() {
        let receiveValueExpectation = XCTestExpectation()
        
        // given
        let path = "/path"
        let parameters = ["name": "TestName", "data": "value=space"]
        let fullUrl = [baseUrl + path + "?name=TestName&data=value%3Dspace",
                       baseUrl + path + "?data=value%3Dspace&name=TestName"]
        
        // when
        sut.request(path: path, method: .post, parameters: parameters)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { data, _ in
                
                // then
                if let data = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    XCTAssert(fullUrl.contains(data[kResponseDataUrlKey] as? String ?? ""))
                    XCTAssertEqual((data[kResponseDataMethodKey] as? String)?.uppercased(), "POST")
                    let responseParameters = data[kResponseDataParametersKey] as? [String: String]
                    XCTAssertEqual(responseParameters?["name"], parameters["name"])
                } else {
                    XCTAssert(false, "Could not decode data")
                }
                
                receiveValueExpectation.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [receiveValueExpectation], timeout: 5)
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
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: HTTPClientError.malformedURL)
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        var responseData: [String: Any] = [kResponseDataUrlKey: url.absoluteString]
        
        if let method = request.httpMethod {
            responseData[kResponseDataMethodKey] = method
        }
        
        if let headerFields = request.allHTTPHeaderFields {
            responseData[kResponseDataParametersKey] = headerFields
        }
        
        if let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let data = try? JSONSerialization.data(withJSONObject: responseData, options: []) {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
}
