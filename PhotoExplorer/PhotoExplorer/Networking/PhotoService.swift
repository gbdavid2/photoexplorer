//
//  PhotoService.swift
//  PhotoExplorer
//
//  Created by David Garces on 16/08/2024.
//

import Foundation

/// The `PhotoServiceProtocol` defines the interface for fetching photos and photo details.
/// This allows for dependency injection, enabling easy mocking and testing of the service.
protocol PhotoServiceProtocol {
    /// Fetches an array of `PhotoSummary` objects from a remote source.
    ///
    /// - Returns: An array of `PhotoSummary` objects.
    /// - Throws: A `NetworkError` if the fetch operation fails.
    func fetchPhotos() async throws -> [PhotoSummary]
    
    /// Fetches detailed information about a specific photo.
    ///
    /// - Parameter id: The ID of the photo to fetch details for.
    /// - Returns: A `PhotoDetail` object containing detailed information about the photo.
    /// - Throws: A `NetworkError` if the fetch operation fails.
    func fetchPhotoDetail(for id: String) async throws -> PhotoDetail
}

/// `PhotoService` is responsible for interacting with the Flickr API to fetch photos and their details.
/// This struct conforms to `PhotoServiceProtocol` and provides the actual implementation.
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
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await networkClient.fetchData(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            let decoder = JSONDecoder()
            let photoResponse = try decoder.decode(PhotoResponse.self, from: data)
            
            return photoResponse.photos.photo
            
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    /// Fetches detailed information about a specific photo from the Flickr API.
    ///
    /// - Parameter id: The ID of the photo to fetch details for.
    /// - Returns: A `PhotoDetail` object containing detailed information about the photo.
    /// - Throws: A `NetworkError` in case of failure (e.g., invalid URL, network issues, decoding errors).
    func fetchPhotoDetail(for id: String) async throws -> PhotoDetail {
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=\(apiKey)&photo_id=\(id)&format=json&nojsoncallback=1"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await networkClient.fetchData(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            let decoder = JSONDecoder()
            let photoDetailResponse = try decoder.decode(PhotoDetailResponse.self, from: data)
            
            return photoDetailResponse.photo
            
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}

/// `MockPhotoService` is a mock implementation of `PhotoServiceProtocol`.
/// This struct is used in unit tests to simulate different scenarios (e.g., successful photo fetch, error scenarios).
struct MockPhotoService: PhotoServiceProtocol {
    var mockPhotos: [PhotoSummary]?
    var mockPhotoDetail: PhotoDetail?
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
    
    /// Simulates fetching detailed information about a specific photo. Returns either the mock photo detail or throws a mock error.
    ///
    /// - Parameter id: The ID of the photo to fetch details for.
    /// - Returns: A `PhotoDetail` object containing detailed information about the photo.
    /// - Throws: A `NetworkError` if `mockError` is set.
    func fetchPhotoDetail(for id: String) async throws -> PhotoDetail {
        if let error = mockError {
            throw error
        }
        guard let detail = mockPhotoDetail else {
            throw NetworkError.noData
        }
        return detail
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
    
    /// Mock photo detail to be returned by the fetch detail operation.
    var mockPhotoDetail: PhotoDetail?
    
    /// The delay (in nanoseconds) to simulate network latency.
    var delay: UInt64
    
    /// Simulates fetching photos with a delay. After the delay, it returns the mock photos.
    ///
    /// - Returns: An array of `PhotoSummary` objects.
    /// - Throws: No error is thrown by this mock implementation.
    func fetchPhotos() async throws -> [PhotoSummary] {
        try? await Task.sleep(nanoseconds: delay)
        return mockPhotos ?? []
    }
    
    /// Simulates fetching detailed information about a specific photo with a delay. After the delay, it returns the mock photo detail.
    ///
    /// - Parameter id: The ID of the photo to fetch details for.
    /// - Returns: A `PhotoDetail` object containing detailed information about the photo.
    /// - Throws: No error is thrown by this mock implementation.
    func fetchPhotoDetail(for id: String) async throws -> PhotoDetail {
        try? await Task.sleep(nanoseconds: delay)
        guard let detail = mockPhotoDetail else {
            throw NetworkError.noData
        }
        return detail
    }
}
