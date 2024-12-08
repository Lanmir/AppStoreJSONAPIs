//
//  AppGroup.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 06/11/24.
//

import Foundation
//apps data structure
struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable, Hashable{
    let   id, name, artistName, artworkUrl100: String
}
