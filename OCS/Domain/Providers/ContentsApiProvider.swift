//
//  ContentsApiProvider.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 19/11/2021.
//

import Combine

protocol ContentsApiProvider: AnyObject {
    func searchContents(title: String) -> AnyPublisher<[Content], Error>
}
