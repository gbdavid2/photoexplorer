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
        let total: String
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
struct PhotoSummary: Decodable {
    let id: String
    let title: String
    let thumbnailURL: URL?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case thumbnailURLString = "thumbnailURL"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)

        let urlString = try container.decode(String.self, forKey: .thumbnailURLString)

        if #available(iOS 17, *) {
            // Use the stricter URL validation in iOS 17
            if let url = URL(string: urlString, encodingInvalidCharacters: false),
               url.scheme == "http" || url.scheme == "https" {
                thumbnailURL = url
            } else {
                thumbnailURL = nil
            }
        } else {
            // Fallback to the older URL initializer for iOS 16 and below
            if let url = URL(string: urlString),
               url.scheme == "http" || url.scheme == "https" {
                thumbnailURL = url
            } else {
                thumbnailURL = nil
            }
        }
    }
}
