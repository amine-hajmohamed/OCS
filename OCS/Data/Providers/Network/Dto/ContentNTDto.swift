//
//  ContentNTDto.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 19/11/2021.
//

import Foundation

struct ContentSearchResultNTDto: Decodable {
    let contents: [ContentNTDto]?
}

struct ContentNTDto: Decodable {
    let title: [TitleNTDto]?
    let subtitle: String?
    let imageurl: String?
    
    func toEntity() -> Content? {
        guard let title = title?.first?.value, let subtitle = subtitle, let imageurl = imageurl else {
            return nil
        }

        return Content(title: title, subTitle: subtitle, imageURL: imageurl)
    }
}

struct TitleNTDto: Decodable {
    let value: String?
}
