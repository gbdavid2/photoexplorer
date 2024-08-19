//
//  NetworkError.swift
//  PhotoExplorer
//
//  Created by David Garces on 17/08/2024.
//

/// `NetworkError` is an enumeration that represents various errors that can occur during network operations.
/// It conforms to the `Error` protocol, making it suitable for use with Swift's error handling system.
/// It also conforms to the `Equatable` protocol, allowing for comparison of different `NetworkError` cases.
enum NetworkError: Error, Equatable {
    
    /// Indicates that the provided URL is invalid.
    case invalidURL
    
    /// Represents a general failure during a network request.
    /// The associated `Error` provides more information about the underlying issue.
    case requestFailed(Error)
    
    /// Indicates that the network response received was invalid or unexpected.
    case invalidResponse
    
    /// Indicates that the network request completed successfully, but no data was received.
    case noData
    
    /// Represents a failure during the decoding of the received data.
    /// The associated `Error` provides more information about the decoding issue.
    case decodingError(Error)
    
    /// A fallback case for any unknown errors that don't fit into the other categories.
    case unknown

    /// Conforms to the `Equatable` protocol by defining a custom equality check for `NetworkError`.
    /// This allows comparing two `NetworkError` instances to determine if they represent the same error.
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
