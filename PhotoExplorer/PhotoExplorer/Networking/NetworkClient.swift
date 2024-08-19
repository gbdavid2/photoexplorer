//
//  NetworkClient.swift
//  PhotoExplorer
//
//  Created by David Garces on 16/08/2024.
//

import Foundation

/// `NetworkClient` is a protocol that defines the contract for fetching data from a URL.
/// This allows for flexibility in using different networking implementations, such as real network requests or mocked responses.
protocol NetworkClient {
    /// Fetches data from the specified URL.
    /// - Parameter url: The URL to fetch data from.
    /// - Returns: A tuple containing the fetched data and the associated URL response.
    /// - Throws: An error if the data fetching fails.
    func fetchData(from url: URL) async throws -> (Data, URLResponse)
}

/// `URLSessionClient` is a concrete implementation of `NetworkClient` that uses `URLSession` to perform network requests.
struct URLSessionClient: NetworkClient {
    /// Fetches data from the specified URL using `URLSession`.
    /// - Parameter url: The URL to fetch data from.
    /// - Returns: A tuple containing the fetched data and the associated URL response.
    /// - Throws: An error if the data fetching fails.
    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(from: url)
    }
}

/// `MockNetworkClient` is a mock implementation of `NetworkClient` used for testing purposes.
/// It allows you to simulate different network responses without making real network requests.
struct MockNetworkClient: NetworkClient {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    /// Simulates fetching data from a URL by returning the mock data, response, or error provided.
    /// - Parameter url: The URL to fetch data from.
    /// - Returns: A tuple containing the mock data and the associated URL response.
    /// - Throws: An error if `mockError` is set.
    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        
        let response = mockResponse ?? HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (mockData ?? Data(), response)
    }
}
