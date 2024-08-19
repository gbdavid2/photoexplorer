//
//  Photo.swift
//  PhotoExplorer
//
//  Created by David Garces on 16/08/2024.
//
// This file contains the `Photo`, `PhotoSummary`, `PhotoResponse`, and `PhotoDetail` structs.
// These models represent different aspects of the data returned by the Flickr API and are used
// within the app to handle and display photo information.
//
// - `PhotoResponse`: Represents the top-level response structure from the Flickr API when searching for photos.
//    It includes metadata about the search and a list of `PhotoSummary` objects.
//
// - `PhotoSummary`: Represents the summary information of a photo, including its ID, title, and thumbnail URL.
//    This struct is primarily used for displaying a grid of photos.
//
// - `PhotoDetail`: Represents detailed information about a specific photo, fetched from the Flickr API when
//    the user selects a photo for more information. It includes details such as the title, description,
//    owner, date taken, and the URL for the photo.
//
// These structs are kept together in this file to maintain organization and avoid unnecessary file proliferation,
// making it easier to manage and understand the data flow within the app.

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

/// `PhotoDetail` represents the minimal detailed information of a photo fetched from the Flickr API.
/// It contains only the most essential fields, such as the photo's ID, title, description, owner, date taken, and an image URL.
struct PhotoDetail: Decodable, Equatable {
    let id: String
    let title: String
    let description: String
    let owner: String
    let dateTaken: String
    let imageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "title._content"
        case description = "description._content"
        case owner = "owner.username"
        case dateTaken = "dates.taken"
        case urls
    }
    
    enum URLKeys: String, CodingKey {
        case url
    }
    
    enum URLContentKeys: String, CodingKey {
        case _content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        owner = try container.decode(String.self, forKey: .owner)
        dateTaken = try container.decode(String.self, forKey: .dateTaken)
        
        // Decode the URL array and take the first URL (assuming it's the primary photo URL)
        let urlsContainer = try container.nestedContainer(keyedBy: URLKeys.self, forKey: .urls)
        var urlArray = try urlsContainer.nestedUnkeyedContainer(forKey: .url)
        let urlContentContainer = try urlArray.nestedContainer(keyedBy: URLContentKeys.self)
        imageURL = try urlContentContainer.decode(URL.self, forKey: ._content)
    }
    
    /// Custom initializer to allow creating a `PhotoDetail` with modified properties, such as a formatted date.
    init(id: String, title: String, description: String, owner: String, dateTaken: String, imageURL: URL?) {
        self.id = id
        self.title = title
        self.description = description
        self.owner = owner
        self.dateTaken = dateTaken
        self.imageURL = imageURL
    }
}
