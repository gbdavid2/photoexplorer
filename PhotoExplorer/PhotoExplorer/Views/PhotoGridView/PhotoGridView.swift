import SwiftUI

/// `PhotoGridView` is a view that displays a scrollable grid of photos fetched from the Flickr API.
/// It manages the loading and error states and presents the photo grid.
/// Navigation and other UI elements are managed by the parent view that embeds this view.
struct PhotoGridView: View {
    @StateObject private var viewModel: PhotoViewModel

    /// Initializes the `PhotoGridView` with a `PhotoViewModel`.
    /// - Parameter viewModel: The view model responsible for fetching and managing the photo data.
    init(viewModel: PhotoViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading Photos...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            } else {
                ScrollView {
                    LazyVGrid(columns: gridLayout, spacing: 20) {
                        ForEach(viewModel.photos) { photo in
                            PhotoTileView(photo: photo)
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
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
    PhotoGridView(viewModel: mockViewModel)
}
