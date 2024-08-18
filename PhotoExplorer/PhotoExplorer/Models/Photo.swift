//
//  Photo.swift
//  PhotoExplorer
//
//  Created by David Garces on 16/08/2024.
//
// This file contains both the `Photo` and `PhotoResponse` structs.
// They are included together to keep the project organized and avoid
// unnecessary file proliferation since this is a small project.
//
// `PhotoResponse` represents the raw data received from the Flickr API,
// while `Photo` is the model used within the app to work with this data.
//

import Foundation

/// `PhotoResponse` represents the top-level response structure returned by the Flickr API when searching for photos.
/// This struct encapsulates the metadata about the search (like the current page, total pages, etc.) as well as the list of photos returned.
/// We use it to decode the full JSON response and extract both the metadata and the array of photos.
struct PhotoResponse: Decodable {
    let photos: PhotoContainer

    /// `PhotoContainer` is a nested structure within `PhotoResponse` that holds the metadata about the photo search results.
    /// This includes pagination information such as the current page, total pages, and the number of photos per page.
    /// Additionally, it contains an array of `PhotoSummary` objects, which represent the individual photos returned by the search.
    struct PhotoContainer: Decodable {
        let page: Int
        let pages: Int
        let perpage: Int
        let total: Int
        let photo: [PhotoSummary]
    }
}

/// `Photo` is the business model used within the app, derived from `PhotoResponse`.
/// It contains the relevant fields and any additional processing needed for use in the UI or logic.
struct Photo: Decodable {
    let id: String
    let title: String
}

/// `PhotoSummary` represents the raw JSON data structure returned by the Flickr API.
/// This struct is used primarily for decoding the API response for each photo summary.
/// The decoded data will be used in an array of photos when launching the app.
/// It is only `Decodable` because we don't need to send data back to the server or save to disk at this stage.
/// `PhotoSummary` is `Identifiable` so that we can iterate over elements when required
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

        // Construct the thumbnail URL from the farm, server, id, and secret fields
        let farm = try container.decode(Int.self, forKey: .farm)
        let server = try container.decode(String.self, forKey: .server)
        let secret = try container.decode(String.self, forKey: .secret)
        thumbnailURL = URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")
    }
    
    // Custom initializer for testing and other manual creation (e.g. previews)
    init(id: String, title: String, thumbnailURL: URL?) {
        self.id = id
        self.title = title
        self.thumbnailURL = thumbnailURL
    }

    // Implement Equatable protocol to allow comparison in tests
    static func ==(lhs: PhotoSummary, rhs: PhotoSummary) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.thumbnailURL == rhs.thumbnailURL
    }
}
