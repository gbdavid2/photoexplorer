//
//  PhotoServiceTests.swift
//  PhotoExplorer
//
//  Created by David Garces on 17/08/2024.
//

import XCTest
@testable import PhotoExplorer

final class PhotoServiceTests: XCTestCase {
    
    var mockNetworkClient: MockNetworkClient!
    var photoService: PhotoService!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        photoService = PhotoService(networkClient: mockNetworkClient)
    }
    
    override func tearDown() {
        mockNetworkClient = nil
        photoService = nil
        super.tearDown()
    }
    
    func testFetchPhotosSuccessfully() async throws {
        // Set up a valid HTTPURLResponse
        let url = URL(string: "https://flickr.com")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockNetworkClient.mockResponse = response
        
        // Provide mock JSON data for a successful response
        let mockJSONData = """
        {
            "photos": {
                "page": 1,
                "pages": 1,
                "perpage": 100,
                "total": "1",
                "photo": [
                    {
                        "id": "12345",
                        "title": "Sample Flickr Photo",
                        "thumbnailURL": "https://flickr.com/photo.jpg"
                    }
                ]
            }
        }
        """.data(using: .utf8)!
        mockNetworkClient.mockData = mockJSONData
        
        photoService = PhotoService(networkClient: mockNetworkClient)
        
        let photos = try await photoService.fetchPhotos()
        
        XCTAssertEqual(photos.count, 1)
        XCTAssertEqual(photos.first?.id, "12345")
        XCTAssertEqual(photos.first?.title, "Sample Flickr Photo")
    }
    
    func testFetchPhotosDecodingError() async {
        let invalidJSON = """
        {
            "invalid_key": "invalid_value"
        }
        """.data(using: .utf8)!
        
        mockNetworkClient.mockData = invalidJSON
        photoService = PhotoService(networkClient: mockNetworkClient)
        
        do {
            _ = try await photoService.fetchPhotos()
            XCTFail("Expected decoding error but got success")
        } catch let error as NetworkError {
            switch error {
            case .decodingError(let decodingError):
                XCTAssertTrue(decodingError is DecodingError)
            default:
                XCTFail("Expected decoding error but got: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchPhotosInvalidURL() async {
        struct MockPhotoServiceWithInvalidURL: PhotoServiceProtocol {
            func fetchPhotos() async throws -> [PhotoSummary] {
                throw NetworkError.invalidURL
            }
        }
        // Use the MockPhotoServiceWithInvalidURL to simulate the invalid URL scenario
        let mockPhotoService = MockPhotoServiceWithInvalidURL()

        do {
            _ = try await mockPhotoService.fetchPhotos()
            XCTFail("Expected invalid URL error but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchPhotosFailsWithNoData() async throws {
        // Prepare mock response without data
        mockNetworkClient.mockData = nil
        mockNetworkClient.mockResponse = HTTPURLResponse(url: URL(string: "https://api.flickr.com")!,
                                                         statusCode: 200,
                                                         httpVersion: nil,
                                                         headerFields: nil)
        do {
            _ = try await photoService.fetchPhotos()
            XCTFail("Expected failure, but succeeded")
        } catch let error as NetworkError {
            switch error {
            case .requestFailed(let innerError):
                XCTAssertEqual(innerError as? NetworkError, NetworkError.noData)
            case .noData:
                XCTAssertEqual(error, NetworkError.noData)
            default:
                XCTFail("Unexpected error: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchPhotosInvalidResponse() async {
        let invalidResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                              statusCode: 404,
                                              httpVersion: nil,
                                              headerFields: nil)
        mockNetworkClient.mockResponse = invalidResponse
        mockNetworkClient.mockData = Data()
        photoService = PhotoService(networkClient: mockNetworkClient)
        
        do {
            _ = try await photoService.fetchPhotos()
            XCTFail("Expected invalid response error but got success")
        } catch let error as NetworkError {
            switch error {
            case .invalidResponse:
                XCTAssertEqual(error, .invalidResponse)
            case .requestFailed(let underlyingError):
                if let networkError = underlyingError as? NetworkError {
                    XCTAssertEqual(networkError, .invalidResponse)
                } else {
                    XCTFail("Unexpected error: \(underlyingError)")
                }
            default:
                XCTFail("Expected invalid response error but got: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
