//
//  PhotoExplorerTests.swift
//  PhotoExplorerTests
//
//  Created by David Garces on 14/08/2024.
//

import XCTest
@testable import PhotoExplorer

final class PhotoExplorerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
//    func testFetchPhotoDetails() async throws {
//        // Setup the mock client with expected data
//        let mockJSONData = """
//        {
//            "photo": {
//                "id": "12345",
//                "dateuploaded": "1234567890",
//                "owner": {
//                    "nsid": "owner123",
//                    "username": "TestUser",
//                    "realname": "Test User",
//                    "location": "Test Location"
//                },
//                "title": {
//                    "_content": "Sample Title"
//                },
//                "description": {
//                    "_content": "Sample Description"
//                },
//                "tags": {
//                    "tag": [
//                        {"id": "1", "author": "author1", "raw": "tag1", "_content": "tag1"}
//                    ]
//                },
//                "location": {
//                    "latitude": "0.0",
//                    "longitude": "0.0",
//                    "locality": {"_content": "Test Locality"},
//                    "county": {"_content": "Test County"},
//                    "region": {"_content": "Test Region"},
//                    "country": {"_content": "Test Country"}
//                },
//                "urls": {
//                    "url": [
//                        {"type": "photopage", "_content": "https://www.example.com"}
//                    ]
//                },
//                "media": "photo"
//            }
//        }
//        """.data(using: .utf8)!
//
//        let mockClient = MockNetworkClient(mockData: mockJSONData)
//        let photoService = PhotoService(networkClient: mockClient)
//        
//        // Test
//        let photoDetails = try await photoService.fetchPhoto(by: "12345")
//        
//        // Assertions
//        XCTAssertEqual(photoDetails.id, "12345")
//        XCTAssertEqual(photoDetails.title._content, "Sample Title")
//        XCTAssertEqual(photoDetails.owner.username, "TestUser")
//        // Add more assertions as needed
//    }

    func testFetchSinglePhoto() throws {
        // let photoService = PhotoService()
    }
}
