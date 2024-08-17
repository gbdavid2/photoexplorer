//
//  NetworkError.swift
//  PhotoExplorer
//
//  Created by David Garces on 17/08/2024.
//

enum NetworkError: Error, Equatable {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case noData
    case decodingError(Error)
    case unknown

    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.noData, .noData):
            return true
        case (.unknown, .unknown):
            return true
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.requestFailed(let lhsError), .requestFailed(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
