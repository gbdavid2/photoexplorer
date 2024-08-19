//
//  PhotoGrid.swift
//  PhotoExplorer
//
//  Created by David Garces on 18/08/2024.
//

import SwiftUI

/// `PhotoGrid` is a view that displays a grid of photos using `PhotoTileView` elements.
/// It leverages `LazyVGrid` to efficiently render a large number of photos in a scrollable grid layout.
/// Each photo is displayed as a tile within the grid.
struct PhotoGrid: View {
    let photos: [PhotoSummary]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            ForEach(photos) { photo in
                PhotoTileView(photo: photo)
            }
        }
        .padding()
    }
}

#Preview {
    // Previewing the grid with a collection of sample photos.
    // This shows how multiple tiles look together in a grid layout.
    ScrollView {
        PhotoGrid(photos: [
            PhotoSummary(id: "1", title: "Sample Photo 1", thumbnailURL: URL(string: "https://via.placeholder.com/100")),
            PhotoSummary(id: "2", title: "Sample Photo 2", thumbnailURL: URL(string: "https://via.placeholder.com/100")),
            PhotoSummary(id: "3", title: "Sample Photo 3", thumbnailURL: URL(string: "https://via.placeholder.com/100"))
        ])
    }
    .padding()
}
