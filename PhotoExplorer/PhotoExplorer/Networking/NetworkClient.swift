//
//  NetworkClient.swift
//  PhotoExplorer
//
//  Created by David Garces on 16/08/2024.
//

import Foundation

protocol NetworkClient {
    func fetchData(from url: URL) async throws -> Data
}

struct URLSessionClient: NetworkClient {
    func fetchData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

struct MockNetworkClient: NetworkClient {
    var mockData: Data?
    var mockError: Error?
    
    func fetchData(from url: URL) async throws -> Data {
        if let error = mockError {
            throw error
        }
        return mockData ?? Data()
    }
}
