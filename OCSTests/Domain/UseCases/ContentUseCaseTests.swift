//
//  ContentUseCaseTests.swift
//  OCSTests
//
//  Created by Mohamed Amine HAJ MOHAMED on 21/11/2021.
//
// swiftlint:disable implicitly_unwrapped_optional

import XCTest
import Combine
@testable import OCS

class ContentUseCaseTests: XCTestCase {
    
    private var sut: ContentUseCase!
    private var subscriptions: Set<AnyCancellable> = []
    
    private let dataStub = [
        Content(title: "title", subTitle: "subTitle", imageURL: "imageURL"),
        Content(title: "title2", subTitle: "subTitle2", imageURL: nil)
    ]
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ContentUseCase(contentsApiProvider: ContentsApiProviderStub(contents: dataStub))
    }
    
    override func tearDownWithError() throws {
        subscriptions = []
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_searchContents() {
        // given
        let data = self.dataStub
        
        // when
        sut.searchContents("")
            .sink(receiveCompletion: { _ in },
                  receiveValue: { contents in
                // then
                XCTAssertEqual(contents, data)
            })
            .store(in: &subscriptions)
    }
}

// MARK: - ContentsApiProviderStub
private class ContentsApiProviderStub: ContentsApiProvider {
    
    private let contents: [Content]
    
    init(contents: [Content]) {
        self.contents = contents
    }
    
    func searchContents(title: String) -> AnyPublisher<[Content], Error> {
        Just(contents)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
