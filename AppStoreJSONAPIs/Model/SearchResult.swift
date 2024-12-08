//
//  SearchResult.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 04/11/24.
//

import Foundation
//MARK: JSON Decodable items
struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    var averageUserRating : Float?
    let screenshotUrls: [String]?
    let artworkUrl100: String // app icon
    var formattedPrice: String?
    let description: String?
    var releaseNotes: String?
    var artistName: String?
    var collectionName: String?
}
