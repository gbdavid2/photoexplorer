//
//  PhotoTests.swift
//  PhotoExplorer
//
//  Created by David Garces on 17/08/2024.
//

import XCTest
@testable import PhotoExplorer

final class PhotoTests: XCTestCase {
    func testPhotoSummaryDecodingFromValidJSON() throws {
        // A mock JSON with a valid structure
        let mockJSONData = """
        {
            "id": "12345",
            "title": "Sample Photo",
            "thumbnailURL": "https://example.com/photo.jpg"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let photoSummary = try decoder.decode(PhotoSummary.self, from: mockJSONData)
        
        // The decoded PhotoSummary should match the expected values
        XCTAssertEqual(photoSummary.id, "12345")
        XCTAssertEqual(photoSummary.title, "Sample Photo")
        XCTAssertEqual(photoSummary.thumbnailURL?.absoluteString, "https://example.com/photo.jpg")
    }
    
    func testPhotoSummaryDecodingFailsWithMissingFields() throws {
        // A mock JSON that is missing the URL field
        let mockJSONData = """
        {
            "id": "12345",
            "thumbnailURL": "https://example.com/photo.jpg"
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(PhotoSummary.self, from: mockJSONData)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testPhotoSummaryDecodingWithInvalidURLReturnsNil() throws {
        // A mock JSON with an invalid URL format
        let mockJSONData = """
        {
            "id": "12345",
            "title": "Sample Photo",
            "thumbnailURL": "invalid-url"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let photoSummary = try decoder.decode(PhotoSummary.self, from: mockJSONData)

        // The thumbnailURL should be nil because the URL was invalid
        XCTAssertNil(photoSummary.thumbnailURL)
    }
    
    func testPhotoSummaryDecodingSucceedsWithExtraFields() throws {
        // A mock JSON with extra fields not present in the PhotoSummary struct
        let mockJSONData = """
        {
            "id": "12345",
            "title": "Sample Photo",
            "thumbnailURL": "https://example.com/photo.jpg",
            "extraField": "extraValue"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let photoSummary = try decoder.decode(PhotoSummary.self, from: mockJSONData)

        // The decoded PhotoSummary should match the expected values and ignore the extra field
        XCTAssertEqual(photoSummary.id, "12345")
        XCTAssertEqual(photoSummary.title, "Sample Photo")
        XCTAssertEqual(photoSummary.thumbnailURL?.absoluteString, "https://example.com/photo.jpg")
    }
    
}
