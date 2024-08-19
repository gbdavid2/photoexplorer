//
//  PhotoDetailViewModel.swift
//  PhotoExplorer
//
//  Created by David Garces on 18/08/2024.
//

import Foundation

/// `PhotoDetailViewModel` is responsible for managing the state and logic for displaying the details of a specific photo.
/// It interacts with `PhotoService` to fetch detailed information about a photo when the user selects it.
@MainActor
class PhotoDetailViewModel: ObservableObject {
    
    /// The detailed information of the selected photo.
    @Published var photoDetail: PhotoDetail?
    
    /// Indicates whether the view model is currently loading data.
    @Published var isLoading: Bool = false
    
    /// Stores error messages in case of a failure during data fetching.
    @Published var errorMessage: String?
    
    /// The service responsible for fetching the photo details.
    private let photoService: PhotoServiceProtocol
    
    /// Initializes the `PhotoDetailViewModel` with a specific photo service.
    ///
    /// - Parameter photoService: The service used to fetch photo details. Defaults to `PhotoService`.
    init(photoService: PhotoServiceProtocol = PhotoService()) {
        self.photoService = photoService
    }
    
    /// Fetches the detailed information of a photo by its ID.
    ///
    /// This function updates the `photoDetail` property with the fetched data or sets the `errorMessage` if the request fails.
    /// It also manages the `isLoading` state to indicate when the fetch operation is in progress.
    ///
    /// - Parameter photoID: The ID of the photo to fetch details for.
    func fetchPhotoDetail(photoID: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let detail = try await photoService.fetchPhotoDetail(for: photoID)
            // Format the date before assigning it to the published property
            let formattedDetail = formatPhotoDetail(detail)
            photoDetail = formattedDetail
        } catch {
            // Handle various network errors by setting an appropriate error message
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
                    errorMessage = "Failed to load photo details."
                }
            } else {
                errorMessage = "An unexpected error occurred."
            }
        }
        
        isLoading = false
    }
    
    /// Formats the `PhotoDetail` instance by converting the `dateTaken` field into a more user-friendly format.
    ///
    /// - Parameter detail: The `PhotoDetail` object containing the original data.
    /// - Returns: A new `PhotoDetail` instance with the formatted date.
    private func formatPhotoDetail(_ detail: PhotoDetail) -> PhotoDetail {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Original format from the API

        var formattedDate = detail.dateTaken
        if let date = dateFormatter.date(from: detail.dateTaken) {
            // Set the user-friendly date format
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            formattedDate = dateFormatter.string(from: date)
        }

        // Return a new PhotoDetail instance with the formatted date
        return PhotoDetail(
            id: detail.id,
            title: detail.title,
            description: detail.description,
            owner: detail.owner,
            dateTaken: formattedDate,
            imageURL: detail.imageURL
        )
    }
}
