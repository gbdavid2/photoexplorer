//
//  Photo.swift
//  PhotoExplorer
//
//  Created by David Garces on 16/08/2024.
//
// This file contains the `Photo` struct, which is a simplified version of the `PhotoSummary`
// and `PhotoDetail` models, representing the minimal information needed for displaying a photo.

import Foundation

/// `Photo` is a simplified model used within the app, derived from `PhotoSummary`.
/// It contains only the essential fields necessary for the app's logic and UI.
struct Photo: Decodable {
    let id: String
    let title: String
}
