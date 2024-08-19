//
//  PhotoDetail.swift
//  PhotoExplorer
//
//  Created by David Garces on 16/08/2024.
//
// This file contains the `PhotoDetail` struct, which represents detailed information about a
// specific photo fetched from the Flickr API. It also includes a sample instance for use in
// previews and tests.

import Foundation

/// `PhotoDetail` represents the detailed information about a specific photo fetched from the Flickr API.
/// It contains the photo's ID, title, description, owner, date taken, and a URL for the image.
struct PhotoDetail: Decodable, Equatable {
    let id: String
    let title: String
    let description: String
    let owner: String
    let dateTaken: String
    let imageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case owner
        case dates
        case urls
        case farm
        case server
        case secret
    }
    
    enum TitleKeys: String, CodingKey {
        case _content
    }
    
    enum DescriptionKeys: String, CodingKey {
        case _content
    }
    
    enum OwnerKeys: String, CodingKey {
        case username
    }
    
    enum DatesKeys: String, CodingKey {
        case taken
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
        
        // Decode title
        let titleContainer = try container.nestedContainer(keyedBy: TitleKeys.self, forKey: .title)
        title = try titleContainer.decode(String.self, forKey: ._content)
        
        // Decode description
        let descriptionContainer = try container.nestedContainer(keyedBy: DescriptionKeys.self, forKey: .description)
        description = try descriptionContainer.decode(String.self, forKey: ._content)
        
        // Decode owner
        let ownerContainer = try container.nestedContainer(keyedBy: OwnerKeys.self, forKey: .owner)
        owner = try ownerContainer.decode(String.self, forKey: .username)
        
        // Decode date taken
        let datesContainer = try container.nestedContainer(keyedBy: DatesKeys.self, forKey: .dates)
        dateTaken = try datesContainer.decode(String.self, forKey: .taken)
        
        // Decode farm, server, and secret
        let farm = try container.decode(Int.self, forKey: .farm)
        let server = try container.decode(String.self, forKey: .server)
        let secret = try container.decode(String.self, forKey: .secret)
        
        // Construct the direct image URL.
        imageURL = URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_b.jpg")
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
    
    /// A sample `PhotoDetail` instance for use in previews and tests.
    static let sample = PhotoDetail(
        id: "12345",
        title: "Sample Photo Title",
        description: "This is a sample description for the photo. It provides more context and background about the photo, explaining what the viewer is seeing.",
        owner: "John Doe",
        dateTaken: "2024-08-20 12:34:56",
        imageURL: URL(string: "https://via.placeholder.com/400")
    )
}

/// `PhotoDetailResponse` represents the outer JSON structure that contains the `photo` key.
struct PhotoDetailResponse: Decodable {
    let photo: PhotoDetail
}
