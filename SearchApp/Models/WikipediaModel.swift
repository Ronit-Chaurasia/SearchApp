//
//  WikipediaModel.swift
//  Ronit_HiveAssignment
//
//  Created by Ronit Chaurasia on 27/05/24.
//

import Foundation

struct WikipediaModel: Codable{
    let query: Query
}

struct Query: Codable{
    let pages: [String: WikipediaPage]
}

struct WikipediaPage: Codable{
    let pageid: Int
    let title: String
    let extract: String
    let thumbnail: Thumbnail?
}

struct Thumbnail: Codable{
    let source: String
    let height: Int
    let width: Int
}
