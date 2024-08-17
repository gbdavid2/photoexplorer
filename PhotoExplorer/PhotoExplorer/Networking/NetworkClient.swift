//
//  NetworkClient.swift
//  PhotoExplorer
//
//  Created by David Garces on 16/08/2024.
//

import Foundation

protocol NetworkClient {
    func fetchData(from url: URL) async throws -> (Data, URLResponse)
}

struct URLSessionClient: NetworkClient {
    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(from: url)
    }
}

struct MockNetworkClient: NetworkClient {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        
        let response = mockResponse ?? HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (mockData ?? Data(), response)
    }
}
