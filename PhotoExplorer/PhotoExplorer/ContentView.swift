//
//  ContentView.swift
//  PhotoExplorer
//
//  Created by David Garces on 14/08/2024.
//

import SwiftUI

/// `ContentView` is the main view of the application that displays a grid of photos.
/// When a photo is selected, it shows detailed information about the photo in a card-like view.
/// The view supports navigation and handles both the loading and error states during the fetching of photo details.
struct ContentView: View {
    @StateObject private var viewModel = PhotoViewModel()
    @State private var selectedPhoto: PhotoSummary?
    @StateObject private var detailViewModel = PhotoDetailViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color and overlay
                Color(.background)
                    .ignoresSafeArea()
                    .overlay(
                        Image(Constants.blob1)
                            .offset(x: Constants.blobOffsetX, y: Constants.blobOffsetY)
                            .accessibility(hidden: true)
                    )
                
                if selectedPhoto != nil {
                    // Detail view section: Loading, displaying, or error handling
                    if detailViewModel.isLoading {
                        ProgressView("Loading details...")
                    } else if let photoDetail = detailViewModel.photoDetail {
                        // Display photo details with a slide transition
                        PhotoDetailView(photoDetail: photoDetail) {
                            withAnimation {
                                self.selectedPhoto = nil
                            }
                        }
                        .transition(.slide)
                    } else if let errorMessage = detailViewModel.errorMessage {
                        // Display error message if fetching details fails
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                } else {
                    // Grid view section: Displaying photo grid and handling photo selection
                    PhotoGridView(viewModel: viewModel) { photo in
                        withAnimation {
                            selectedPhoto = photo
                            // Fetch photo details when a photo is selected
                            Task {
                                await detailViewModel.fetchPhotoDetail(photoID: photo.id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Photo Explorer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Constants for background image positioning
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
