//
//  PhotoSummary.swift
//  PhotoExplorer
//
//  Created by David Garces on 16/08/2024.
//
// This file contains the `PhotoSummary` struct, which represents the summary information
// of a photo, including its ID, title, and thumbnail URL. This struct is primarily used
// for displaying a grid of photos.

import Foundation

/// `PhotoSummary` represents the raw JSON data structure returned by the Flickr API.
/// This struct is used primarily for decoding the API response for each photo summary.
/// The decoded data will be used in an array of photos when launching the app.
/// It is only `Decodable` because we don't need to send data back to the server or save to disk at this stage.
/// `PhotoSummary` is `Identifiable` so that we can iterate over elements when required.
struct PhotoSummary: Decodable, Equatable, Identifiable {
    let id: String
    let title: String
    let thumbnailURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case farm
        case server
        case secret
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        
        // Construct the thumbnail URL from the farm, server, id, and secret fields.
        let farm = try container.decode(Int.self, forKey: .farm)
        let server = try container.decode(String.self, forKey: .server)
        let secret = try container.decode(String.self, forKey: .secret)
        thumbnailURL = URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")
    }
    
    // Custom initializer for testing and other manual creation (e.g., previews).
    init(id: String, title: String, thumbnailURL: URL?) {
        self.id = id
        self.title = title
        self.thumbnailURL = thumbnailURL
    }
    
    // Implement Equatable protocol to allow comparison in tests.
    static func ==(lhs: PhotoSummary, rhs: PhotoSummary) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.thumbnailURL == rhs.thumbnailURL
    }
}
