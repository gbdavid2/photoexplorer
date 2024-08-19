//
//  PhotoResponse.swift
//  PhotoExplorer
//
//  Created by David Garces on 16/08/2024.
//
// This file contains the `PhotoResponse` struct, which represents the top-level response
// structure returned by the Flickr API when searching for photos. It includes metadata
// about the search and a list of `PhotoSummary` objects.

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
