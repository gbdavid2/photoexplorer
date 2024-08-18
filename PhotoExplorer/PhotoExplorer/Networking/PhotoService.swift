//
//  PhotoService.swift
//  PhotoExplorer
//
//  Created by David Garces on 16/08/2024.
//

import Foundation

/// The `PhotoServiceProtocol` defines the interface for fetching photos. This allows us to mock our object so that we can use it in tests.
protocol PhotoServiceProtocol {
    /// Fetches an array of `PhotoSummary` objects from a remote source.
    ///
    /// - Returns: An array of `PhotoSummary` objects.
    /// - Throws: A `NetworkError` if the fetch operation fails.
    func fetchPhotos() async throws -> [PhotoSummary]
}

/// `PhotoService` is responsible for interacting with the Flickr API to fetch photos.
/// This struct conforms to `PhotoServiceProtocol` and provides the actual implementation for fetching photos.
struct PhotoService: PhotoServiceProtocol {
    private let apiKey: String
    private let networkClient: NetworkClient

    /// Initializes the `PhotoService` with a specified network client.
    ///
    /// - Parameter networkClient: A `NetworkClient` used to perform network requests. Defaults to `URLSessionClient`.
    init(networkClient: NetworkClient = URLSessionClient()) {
        self.apiKey = "YOUR_FLICKR_API_KEY"
        self.networkClient = networkClient
    }

    /// Fetches photos from the Flickr API based on the "Yorkshire" tag.
    ///
    /// This function constructs a URL request, sends it via the network client, and decodes the response into an array of `PhotoSummary` objects.
    ///
    /// - Returns: An array of `PhotoSummary` objects.
    /// - Throws: A `NetworkError` in case of failure (e.g., invalid URL, network issues, decoding errors).
    func fetchPhotos() async throws -> [PhotoSummary] {
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&tags=Yorkshire&format=json&nojsoncallback=1&safe_search=1"
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            // Fetch data from the network client
            let (data, response) = try await networkClient.fetchData(from: url)
            
            // Validate the HTTP response status code
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }

            // Ensure data is not empty
            guard !data.isEmpty else {
                throw NetworkError.noData
            }

            // Decode the response data into `PhotoResponse`
            let decoder = JSONDecoder()
            let photoResponse = try decoder.decode(PhotoResponse.self, from: data)
            
            // Return the array of photos from the response
            return photoResponse.photos.photo
            
        } catch let decodingError as DecodingError {
            // Handle decoding errors specifically
            throw NetworkError.decodingError(decodingError)
        } catch {
            // Handle any other errors
            throw NetworkError.requestFailed(error)
        }
    }
}

/// `MockPhotoService` is a mock implementation of `PhotoServiceProtocol`.
/// This struct is used in unit tests to simulate different scenarios (e.g., successful photo fetch, error scenarios).
struct MockPhotoService: PhotoServiceProtocol {
    var mockPhotos: [PhotoSummary]?
    var mockError: NetworkError?

    /// Simulates fetching photos. Returns either the mock photos or throws a mock error.
    ///
    /// - Returns: An array of `PhotoSummary` objects.
    /// - Throws: A `NetworkError` if `mockError` is set.
    func fetchPhotos() async throws -> [PhotoSummary] {
        if let error = mockError {
            throw error
        }
        return mockPhotos ?? []
    }
}

/// `MockDelayingPhotoService` is a mock implementation of `PhotoServiceProtocol` designed to simulate a delayed network response.
///
/// This mock is specifically created for testing the `isLoading` state in the `PhotoViewModel`.
/// By introducing a delay in the `fetchPhotos` method, this service ensures that the `isLoading`
/// state can be checked reliably during an ongoing fetch operation.
///
/// Key Use Case:
/// - Ensures that the `isLoading` state is `true` while photos are being fetched and returns to `false` after completion.
struct MockDelayingPhotoService: PhotoServiceProtocol {
    /// Mock photos to be returned by the fetch operation.
    var mockPhotos: [PhotoSummary]?
    
    /// The delay (in nanoseconds) to simulate network latency.
    var delay: UInt64
    
    /// Simulates fetching photos with a delay. After the delay, it returns the mock photos.
    ///
    /// - Returns: An array of `PhotoSummary` objects.
    /// - Throws: No error is thrown by this mock implementation.
    func fetchPhotos() async throws -> [PhotoSummary] {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: delay)
        
        return mockPhotos ?? []
    }
}
