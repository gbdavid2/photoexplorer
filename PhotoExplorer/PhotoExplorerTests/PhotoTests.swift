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
        // A mock JSON with a valid structure including all necessary fields
        let mockJSONData = """
        {
            "id": "12345",
            "title": "Sample Photo",
            "farm": 66,
            "server": "65535",
            "secret": "abcdef"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let photoSummary = try decoder.decode(PhotoSummary.self, from: mockJSONData)
        
        // Expected thumbnail URL
        let expectedThumbnailURL = "https://farm66.staticflickr.com/65535/12345_abcdef_m.jpg"
        
        // The decoded PhotoSummary should match the expected values
        XCTAssertEqual(photoSummary.id, "12345")
        XCTAssertEqual(photoSummary.title, "Sample Photo")
        XCTAssertEqual(photoSummary.thumbnailURL?.absoluteString, expectedThumbnailURL)
    }
    
    func testPhotoSummaryDecodingFailsWithMissingFields() throws {
        // A mock JSON that is missing the 'title' field, which is required
        let mockJSONData = """
        {
            "id": "12345",
            "farm": 66,
            "server": "65535",
            "secret": "abcdef"
        }
        """.data(using: .utf8)!
        
        XCTAssertThrowsError(try JSONDecoder().decode(PhotoSummary.self, from: mockJSONData)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
        
    func testPhotoSummaryDecodingSucceedsWithExtraFields() throws {
        // A mock JSON with extra fields not present in the PhotoSummary struct
        let mockJSONData = """
        {
            "id": "12345",
            "title": "Sample Photo",
            "farm": 66,
            "server": "65535",
            "secret": "abcdef",
            "extraField": "extraValue"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let photoSummary = try decoder.decode(PhotoSummary.self, from: mockJSONData)
        
        // Expected thumbnail URL
        let expectedThumbnailURL = "https://farm66.staticflickr.com/65535/12345_abcdef_m.jpg"
        
        // The decoded PhotoSummary should match the expected values and ignore the extra field
        XCTAssertEqual(photoSummary.id, "12345")
        XCTAssertEqual(photoSummary.title, "Sample Photo")
        XCTAssertEqual(photoSummary.thumbnailURL?.absoluteString, expectedThumbnailURL)
    }
}
