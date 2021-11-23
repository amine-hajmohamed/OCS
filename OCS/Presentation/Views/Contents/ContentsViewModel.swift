//
//  ContentsViewModel.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 22/11/2021.
//

import Foundation
import Combine

class ContentsViewModel {
    
    // MARK: - Properties
    
    @Published private(set) var message: String?
    @Published private(set) var contents: [Content] = []
    
    @Published private var searchText: String = ""
    
    private let contentUseCase: ContentUseCase
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Initializer
    
    init(contentUseCase: ContentUseCase) {
        self.contentUseCase = contentUseCase
        observeData()
    }
    
    // MARK: - Events
    
    func onViewDidLoad() {
    }
    
    func onSearch(title: String) {
        searchText = title
    }
}

// MARK: Privates
private extension ContentsViewModel {
    
    private func observeData() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.searchContent(title: searchText)
            }
            .store(in: &subscriptions)
    }
    
    private func searchContent(title: String) {
        message = "ContentsViewController.Message.Loading".localized + "..."
        contentUseCase.searchContents(title)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {
                    return
                }
                
                if case .failure(_) = completion {
                    self.contents = []
                    self.message = "ContentsViewController.Message.ErrorMessage".localized
                } else {
                    if self.contents.isEmpty {
                        self.message = "ContentsViewController.Message.NoResult".localized
                    } else {
                        self.message = nil
                    }
                }
            }, receiveValue: { [weak self] contents in
                self?.contents = contents
            })
            .store(in: &subscriptions)
    }
}
