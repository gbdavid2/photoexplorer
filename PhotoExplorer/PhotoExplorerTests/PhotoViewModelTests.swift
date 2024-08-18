//
//  PhotoViewModelTests.swift
//  PhotoExplorer
//
//  Created by David Garces on 17/08/2024.
//

import XCTest
@testable import PhotoExplorer

/// `PhotoViewModelTests` verifies the functionality of the `PhotoViewModel`,
/// which manages state and logic for the photo list view.
///
/// The class uses `@MainActor` because the view model interacts with UI elements,
/// ensuring all updates occur on the main thread.
///
/// The tests cover:
/// - Initial state validation.
/// - Fetching photos, including handling success and error scenarios.
/// - Behavior of published properties like `photos`, `isLoading`, and `errorMessage`.
@MainActor
final class PhotoViewModelTests: XCTestCase {
    
    var mockPhotoService: MockPhotoService!
    var viewModel: PhotoViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        mockPhotoService = MockPhotoService()
        viewModel = PhotoViewModel(photoService: mockPhotoService)
    }
    
    override func tearDown() async throws {
        mockPhotoService = nil
        viewModel = nil
        try await super.tearDown()
    }
    
    func testInitialState() async {
        // Check initial values
        XCTAssertTrue(viewModel.photos.isEmpty, "Expected photos array to be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Expected isLoading to be false initially")
        XCTAssertNil(viewModel.errorMessage, "Expected errorMessage to be nil initially")
    }
    
    func testFetchPhotosSuccess() async {
        let mockPhotos = [PhotoSummary(id: "12345", title: "Sample Photo", thumbnailURL: nil)]
        mockPhotoService.mockPhotos = mockPhotos
        
        // Reinitialise viewModel with the updated mockPhotoService
        viewModel = PhotoViewModel(photoService: mockPhotoService)

        await viewModel.fetchPhotos()

        XCTAssertEqual(viewModel.photos, mockPhotos, "Photos should match the mock data")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after fetching")
        XCTAssertNil(viewModel.errorMessage, "errorMessage should be nil on success")
    }
    
    func testFetchPhotosHandlesError() async {
        let mockError = NetworkError.noData
        mockPhotoService.mockError = mockError
        
        // Reinitialize viewModel with the updated mockPhotoService
        viewModel = PhotoViewModel(photoService: mockPhotoService)

        await viewModel.fetchPhotos()

        XCTAssertTrue(viewModel.photos.isEmpty, "Photos should be empty on error")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after error")
        XCTAssertEqual(viewModel.errorMessage, "No data available.", "errorMessage should match the expected error")
    }
    
    func testIsLoadingStateDuringFetch() async {
        let mockPhotos = [PhotoSummary(id: "12345", title: "Sample Photo", thumbnailURL: nil)]
        mockPhotoService.mockPhotos = mockPhotos
        
        // Initialise viewModel with the updated mockPhotoService
        viewModel = PhotoViewModel(photoService: mockPhotoService)

        XCTAssertFalse(viewModel.isLoading, "isLoading should initially be false")
        
        await viewModel.fetchPhotos()
        
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after fetching")
        XCTAssertEqual(viewModel.photos, mockPhotos, "Photos should match the mock data after fetching")
    }
    
    
    func testIsLoadingStateDuringFetchvv() async {
        let mockPhotos = [PhotoSummary(id: "12345", title: "Sample Photo", thumbnailURL: nil)]
        
        // Initialise the mock service with a delay
        let delayingPhotoService = MockDelayingPhotoService(mockPhotos: mockPhotos, delay: 500_000_000) // 500ms delay
        viewModel = PhotoViewModel(photoService: delayingPhotoService)

        XCTAssertFalse(viewModel.isLoading, "isLoading should initially be false")

        let fetchTask = Task {
            await viewModel.fetchPhotos()
        }

        // Check isLoading during the fetch
        try? await Task.sleep(nanoseconds: 100_000_000) // 100ms to give time for fetch to start

        XCTAssertTrue(viewModel.isLoading, "Expected loading state to be true during fetch")

        await fetchTask.value

        XCTAssertFalse(viewModel.isLoading, "Expected loading state to be false after fetch")
    }
}
