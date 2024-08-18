import SwiftUI

/// `PhotoGridView` is the main view that displays a grid of photos fetched from the Flickr API.
/// It manages the overall layout, including a navigation bar, and handles loading/error states.
struct PhotoGridView: View {
    @StateObject private var viewModel: PhotoViewModel

    /// Initializes the `PhotoGridView` with a `PhotoViewModel`.
    /// - Parameter viewModel: The view model responsible for fetching and managing the photo data.
    init(viewModel: PhotoViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Photos...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else {
                    // Ensuring the grid starts at the top
                    ScrollView {
                        PhotoGrid(photos: viewModel.photos)
                    }
                }
            }
            .navigationTitle("Photo Explorer")
            .task {
                await viewModel.fetchPhotos()
            }
        }
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
    PhotoGridView(viewModel: mockViewModel)
    
}
