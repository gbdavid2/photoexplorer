//
//  Untitled.swift
//  PhotoExplorer
//
//  Created by David Garces on 18/08/2024.
//

import SwiftUI

/// `PhotoTile` represents a single photo in the grid, displaying the photo's thumbnail and title.
struct PhotoTileView: View {
    let photo: PhotoSummary

    var body: some View {
        VStack {
            if let url = photo.thumbnailURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                        .shadow(color: .gray, radius: 4, x: 0, y: 3)
                } placeholder: {
                    Color.gray
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                        .shadow(color: .gray, radius: 4, x: 0, y: 3)
                }
            } else {
                Color.gray
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 4, x: 0, y: 3)
            }
            Text(photo.title)
                .font(.caption)
                .lineLimit(1)
                .padding(.top, 4)
        }
    }
}

#Preview {
    VStack {
        PhotoTileView(photo: PhotoSummary(id: "1", title: "Sample Photo", thumbnailURL: URL(string: "https://via.placeholder.com/100")))
        Spacer()
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .padding()
}
