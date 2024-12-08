//
//  Reviews.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 13/11/24.
//

import Foundation

struct Reviews: Decodable{
    let feed: ReviewFeed
}

struct ReviewFeed: Decodable{
    let entry: [Entry]
}

struct Entry: Decodable {
    let author: Author
    let title: Label
    let content: Label
    
    let rating: Label
    
    private enum CodingKeys: String, CodingKey{
        case author, title, content
        case rating = "im:rating"
    }
}

struct Author: Decodable{
    let name: Label
}

struct Label: Decodable {
    let label: String
}
