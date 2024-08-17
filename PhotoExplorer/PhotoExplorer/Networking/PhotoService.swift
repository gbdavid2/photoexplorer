//
//  PhotoService.swift
//  PhotoExplorer
//
//  Created by David Garces on 16/08/2024.
//

import Foundation

/// The `PhotoServiceProtol` allows us to mock our object so that we can use it in tests
protocol PhotoServiceProtocol {
    func fetchPhotos() async throws -> [PhotoSummary]
}

struct PhotoService: PhotoServiceProtocol {
    private let apiKey = "YOUR_FLICKR_API_KEY"
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = URLSessionClient()) {
        self.networkClient = networkClient
    }

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
}
