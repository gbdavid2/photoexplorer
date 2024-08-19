import SwiftUI

/// `PhotoGridView` is a view that displays a scrollable grid of photos fetched from the Flickr API.
/// It handles the presentation of the photo grid and manages loading and error states.
/// The view also communicates user interactions, such as photo taps, back to the parent view through a closure.
struct PhotoGridView: View {
    @StateObject private var viewModel: PhotoViewModel
    let onPhotoTap: (PhotoSummary) -> Void

    /// Initializes the `PhotoGridView` with a `PhotoViewModel` and a tap action closure.
    ///
    /// - Parameters:
    ///   - viewModel: The view model responsible for fetching and managing the photo data.
    ///   - onPhotoTap: A closure that is triggered when a photo is tapped.
    init(viewModel: PhotoViewModel, onPhotoTap: @escaping (PhotoSummary) -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onPhotoTap = onPhotoTap
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                // Display a loading indicator while photos are being fetched.
                ProgressView("Loading Photos...")
            } else if let errorMessage = viewModel.errorMessage {
                // Display an error message if the fetch operation fails.
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            } else {
                // Display a grid of photos once data is successfully fetched.
                ScrollView {
                    LazyVGrid(columns: gridLayout, spacing: 20) {
                        ForEach(viewModel.photos) { photo in
                            PhotoTileView(photo: photo)
                                .onTapGesture {
                                    // Trigger the onPhotoTap closure when a photo is tapped.
                                    onPhotoTap(photo)
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            // Fetch photos when the view appears.
            await viewModel.fetchPhotos()
        }
    }

    /// Defines the grid layout with three flexible columns.
    private var gridLayout: [GridItem] {
        [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    // Creating a mock view model with sample data for preview purposes.
    let mockViewModel = PhotoViewModel(photoService: MockPhotoService(mockPhotos: [
        PhotoSummary(id: "1", title: "Sample Photo 1", thumbnailURL: URL(string: "https://via.placeholder.com/100")),
        PhotoSummary(id: "2", title: "Sample Photo 2", thumbnailURL: URL(string: "https://via.placeholder.com/100")),
        PhotoSummary(id: "3", title: "Sample Photo 3", thumbnailURL: URL(string: "https://via.placeholder.com/100")),
        PhotoSummary(id: "4", title: "Sample Photo 4", thumbnailURL: URL(string: "https://via.placeholder.com/100"))
    ]))

    // Previewing the PhotoGridView with the mock view model.
    PhotoGridView(viewModel: mockViewModel) { photo in
        print("Photo tapped: \(photo.title)")
    }
}
