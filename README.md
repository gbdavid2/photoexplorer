# Photo Explorer

Photo Explorer is a sample app that showcases the usage of the Flickr API in a SwiftUI application. The app allows users to explore and view photos, including detailed information about each photo.

## Features
- **Photo Grid**: Displays a grid of photos based on a default tag ("Yorkshire").
- **Photo Details**: View detailed information about each photo, including title, date taken, description, and a larger version of the image.

## App Architecture
The app follows the MVVM (Model-View-ViewModel) architecture, ensuring a clear separation of concerns and making the app easier to maintain and test.

- **Model**: Handles the data and business logic. The data model represents the photo and its details retrieved from the Flickr API.
- **View**: SwiftUI views that render the UI elements and respond to user interactions.
- **ViewModel**: Manages the state of the views, handles user inputs, and interacts with the Model to fetch and update data.

## Project Structure
The project is organized to support maintainability, scalability, and testability:

- **Models**: Data structures, such as `Photo`, `PhotoSummary`, and `PhotoDetail`.
- **Networking**: API handling and data fetching, separated for easy testing and modification.
- **ViewModels**: Manages the state and logic for the views.
- **Views**: SwiftUI views organized by feature, with reusable components.
- **Resources**: Manages assets and localization files.

## UI Layout and Design
The app consists of the following screens:

- **Main Screen**: Displays a grid of photos fetched from the Flickr API based on a default tag ("Yorkshire"). Users can tap on a photo to view more details.
- **Detail Screen**: Provides detailed information about the selected photo, including title, date taken, description, and a larger image.

The design follows Apple's Human Interface Guidelines, supporting both light and dark modes.

## Development Tools and Technologies
- **Swift 5.9**: The programming language used for the app.
- **SwiftUI**: The UI framework used to build the app's interface.
- **Xcode 15**: The development environment used.
- **Flickr API**: The external API used to fetch photo data.

## Installation and Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/gbdavid2/photoexplorer.git
   ```
2. Open the project in Xcode:
   ```bash
   open PhotoExplorer.xcodeproj
   ```
3. Search and replace your API Key in the following line
    ```swift
    self.apiKey = "YOUR_FLICKR_API_KEY"
    ```
4. Build and run the app on the simulator or a physical device.

Note: The project will fail to decode data and show an error if you don’t insert a valid API Key. The project does not require an authenticated Flickr User to navigate through the photos but does need a valid API Key to run.


## Justification of Decisions

### 1. **MVVM Architecture**
   - The app is built using the Model-View-ViewModel (MVVM) architecture to promote a clear separation of concerns. 
   - **Model:** Represents the data and business logic (e.g., `Photo`, `PhotoDetail`).
   - **View:** Handles the UI and user interaction (e.g., `ContentView`, `PhotoGridView`, `PhotoDetailView`).
   - **ViewModel:** Manages the state and logic that connects the View and the Model (e.g., `PhotoViewModel`, `PhotoDetailViewModel`).

### 2. **Dependency Injection**
   - The use of protocols (`PhotoServiceProtocol`, `NetworkClient`) and dependency injection allows for easier testing and greater flexibility.
   - Mock services and clients can be injected during testing to simulate various scenarios.

### 3. **Asynchronous Networking**
   - Networking operations are performed asynchronously using Swift's `async/await` API (Swift concurrency) to have a responsive UI. This approach helps in managing long-running tasks like fetching photos without blocking the main thread.

### 4. **Error Handling**
   - Comprehensive error handling is implemented to manage various failure scenarios, such as network issues, invalid URLs, or decoding failures.
   - Errors are communicated to the user via UI elements (e.g., showing error messages in the UI) to ensure a better user experience.

### 5. **Dark Mode Compatibility**
   - The UI components are designed to be fully compatible with both light and dark modes. This is achieved by using system colors and adopting practices that ensure a consistent look and feel across different color schemes.

### 6. **Scalable UI Components**
   - Reusable UI components (`PhotoGrid`, `PhotoTileView`, `PhotoDetailView`) are designed to be flexible and adaptable to different screen sizes and orientations. This ensures that the app can scale easily and maintain a consistent user interface.

### 7. **Code Modularity and Organization**
   - The code is organized into distinct files and modules to maintain clarity and modularity. Each file has a single responsibility, and related components are grouped together to make the codebase more maintainable and easier to navigate.


## Testing

### 1. **Unit Testing**
   - Unit tests were implemented to validate the functionality of the ViewModels, Services, and Model classes.
   - **PhotoViewModel Tests:**
     - Tests for loading photos from the Flickr API.
     - Verification of error handling, such as invalid URLs or network failures.
   - **PhotoService Tests:**
     - Tests the integration with the Flickr API and the correct handling of network requests.
     - Ensures that errors such as invalid responses and decoding errors are correctly handled.
   - **Photo Tests:**
     - Validates the decoding of the `Photo` and `PhotoSummary` structs from the Flickr API responses.
   - **Note:** Due to time constraints, Unit tests for `PhotoDetail` and the `fetchPhotoDetail` workflow are missing. These tests are important for ensuring that the detailed photo data is correctly fetched and presented, and should be prioritized in future development.

### 2. **Mocking Services**
   - **MockPhotoService and MockDelayingPhotoService:** These mock implementations of `PhotoServiceProtocol` were created to simulate various scenarios:
     - **Success Scenarios:** The mock services return predefined data, allowing the app’s handling of valid responses to be tested.
     - **Error Scenarios:** These scenarios simulate different types of errors, such as network failures and decoding issues, to verify the app’s error-handling mechanisms.
     - **Delayed Responses:** `MockDelayingPhotoService` introduces a delay in the `fetchPhotos` method, specifically to test the `isLoading` state in the `PhotoViewModel`. This ensures that the loading indicator behaves correctly during slow network conditions, accurately reflecting the loading state during data fetches.
   - **MockNetworkClient:** This mock is used to simulate network responses, providing control over various network conditions and ensuring the app can handle different response scenarios effectively.
   
### 3. **UI Testing**
   - While UI tests were not implemented due to time constraints, the architecture supports future UI testing.
   - **Potential Tests:**
     - Testing the UI components under different conditions (e.g., loading states, displaying error messages).
     - Verifying that user interactions like tapping on a photo to view details function correctly.
   - **Future Work:**
     - Apple's XCTest framework can be used to write UI tests, simulating user interactions and validating the UI's behavior.
     - Testing the navigation transitions and animations for smooth user experience.
     - Ensuring the app functions correctly across different device sizes and orientations.

### 4. **Swift Previews and Visual Testing**
   - SwiftUI Previews were extensively used to perform visual testing of UI components.
   - Sample data was integrated into previews to verify the appearance and layout of views under various conditions.
   - This approach allowed for rapid iteration on UI design and ensured that components rendered correctly across different configurations, including light and dark modes.

### 5. **Test Coverage**
   - Test coverage focuses on the critical components, ensuring that the app's core logic and functionality work as expected under various scenarios.
   - Although the initial implementation focuses on unit testing the core logic, the structure allows for easy expansion to UI tests in the future.

### 6. **Continuous Testing Approach**
   - A continuous testing approach is recommended for maintaining code quality. As features evolve, tests should be updated and expanded to cover new cases.
   - Mocking services and dependency injection are used throughout to ensure that tests can be isolated and run quickly without reliance on external APIs.

## Future Improvements, Bugs, and Missing Features

### Improvements:
- **URL Building Logic:**
  - Extract the logic to build the URL from `PhotoDetail` to a dedicated utility or configuration file.
  - Extract the URL strings and the logic for building URLs from `PhotoService` and other areas of the model structs. Inject them as dependencies, and consider storing configurable elements in a configuration file.
  
- **API Key Management:**
  - Extract the API key to a more appropriate location, such as a `.plist` file or use environment variables for better security, especially when using CI/CD pipelines.
  
- **Local Data Storage:**
  - Implement local data storage using SwiftData or another storage solution. This would reduce the need for repeated requests to the server, particularly at app launch. Users could manually refresh data by pulling down the list or after a certain period.

- **Content Previews:**
  - Modify the `ContentView` preview to connect to sample data rather than live data, improving test reliability and reducing the risk of unexpected changes.

- **Search Functionality:**
  - Implement a search bar using SwiftUI’s `searchable` modifier to allow users to filter photos by tags, title, or other attributes.

- **Pagination and Infinite Scrolling:**
  - Refactor `PhotoService` to support fetching additional pages in the background as the user scrolls near the bottom of the current results. This will improve the user experience and ensure all available photos are accessible.

- **UI and Integration Tests:**
  - Introduce UI tests and integration tests to validate user interactions and workflows, including the photo detail view, navigation, and error handling.
  
- **Environment Configurations:**
  - Add Xcode schemes to test in different environments (development, testing, production), enabling more robust testing and deployment processes.

### Bugs:
- **Detail View Image Stretching:**
  - Some photos in the detail view may stretch the card beyond its intended size, causing layout issues and clipping the close button.
  
- **Grid Reload Issue:**
  - Each time the user closes a detail view, the main grid view reloads all the images and resets to the top. The grid should remain in its current position, retaining the user's scroll location.

### Missing Features:
- **User Information on Tiles:**
  - The main grid view currently does not display the username of the photo uploader. This information could be added to each tile for better context.

- **Tags on Tiles:**
  - The grid view does not include tags for each photo. To retrieve and display tags, an additional request to the Flickr API's `flickr.photos.getInfo` endpoint is required (for each photo/tile). As a strategy, we can use Swift concurrency and `TaskGroup` to fetch tags in batches for photos currently visible on the screen. The tile design would need to be updated to accommodate the display of tags.

- **Infinite Scrolling Bug:**
  - The main view currently only shows the first page of results. To enable infinite scrolling, additional pages should be fetched and displayed as the user scrolls down.

- **Batch Fetching Strategy:**
  - Implement a batch fetching strategy for tags using Swift concurrency and `TaskGroup`, limiting the fetch to visible photos to reduce server load and improve performance.
