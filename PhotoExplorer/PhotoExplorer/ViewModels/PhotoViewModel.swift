//
//  PhotoViewModel.swift
//  PhotoExplorer
//
//  Created by David Garces on 18/08/2024.
//

import Foundation

/// `PhotoViewModel` is responsible for managing the state and business logic of the photo list view in the app.
/// It interacts with the `PhotoService` to fetch photos from the Flickr API and provides a simple interface for the view to consume.
///
/// The view model uses the `@MainActor` annotation to ensure that all UI-related updates happen on the main thread,
/// which is necessary because SwiftUI views must be updated on the main thread. This class is designed to be an
/// `ObservableObject` so that SwiftUI views can automatically update when the published properties change.
///
/// Key responsibilities:
/// - Fetching photos from the `PhotoService`.
/// - Managing loading state (`isLoading`) to indicate when a network request is in progress.
/// - Handling errors and exposing them through the `errorMessage` property.
/// - Exposing the fetched photos to the view via the `photos` property.
@MainActor
class PhotoViewModel: ObservableObject {
    
    /// A list of photos fetched from the Flickr API. Updated after each successful API call.
    @Published var photos: [PhotoSummary] = []
    
    /// Indicates whether a photo fetch operation is currently in progress. Used to show/hide loading indicators.
    @Published var isLoading: Bool = false
    
    /// Stores error messages when the fetch operation fails. Displayed to the user when an error occurs.
    @Published var errorMessage: String?

    /// The service responsible for fetching photos from the Flickr API. Injected via dependency injection to allow for easy testing and flexibility.
    private let photoService: PhotoServiceProtocol

    init(photoService: PhotoServiceProtocol = PhotoService()) {
        self.photoService = photoService
    }

    /// Fetches photos from the Flickr API using the `PhotoService`.
    /// This method updates the `photos` property with the fetched data or sets the `errorMessage` if the request fails.
    /// It also manages the `isLoading` state to indicate when the fetch operation is in progress.
    func fetchPhotos() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedPhotos = try await photoService.fetchPhotos()
            photos = fetchedPhotos
        } catch {
            if let networkError = error as? NetworkError {
                switch networkError {
                case .invalidURL:
                    errorMessage = "Invalid URL."
                case .noData:
                    errorMessage = "No data available."
                case .invalidResponse:
                    errorMessage = "Invalid response from the server."
                case .decodingError:
                    errorMessage = "Failed to decode data."
                default:
                    errorMessage = "Failed to load photos."
                }
            } else {
                errorMessage = "An unexpected error occurred."
            }
        }
        
        isLoading = false
    }
}
