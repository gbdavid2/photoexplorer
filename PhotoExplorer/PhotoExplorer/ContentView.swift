//
//  ContentView.swift
//  PhotoExplorer
//
//  Created by David Garces on 14/08/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedPhoto: PhotoSummary?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.background).ignoresSafeArea()
                
                if let selectedPhoto = selectedPhoto {
                    // Detail view for the selected photo
                    // PhotoDetailView(photo: selectedPhoto)
                } else {
                    content
                }
            }
            .navigationTitle("Photo Explorer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    /// The main content of the view, displaying a grid of photos
    var content: some View {
        PhotoGridView(viewModel: PhotoViewModel())
            .background(
                Image(Constants.blob1)
                    .offset(x: Constants.blobOffsetX, y: Constants.blobOffsetY)
                    .accessibility(hidden: true)
            )
    }
    
    enum Constants {
        static var blob1 = "Blob"
        static var blobOffsetX = CGFloat(-100)
        static var blobOffsetY = CGFloat(-400)
    }
}

#Preview {
    ContentView()
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
