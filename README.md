# Photo Explorer - DRAFT / TEMPLATE

Photo Explorer is a sample app to showcase the usage of Flicker API in a SwiftUI App.

Photo Explorer is a simple iOS application that allows users to search and view photos from Flickr. Users can explore photos based on
tags, view detailed information about each photo, and browse photos by specific users. The app is built using SwiftUI and adheres to
modern iOS development practices.

## Features
- **Photo Search**: Search for photos based on tags or user IDs.
- **Photo Details**: View detailed information about each photo, including title, date taken, and description.
- **User Photo Browsing**: Browse all photos uploaded by a specific user.

## App Architecture
The app follows the MVVM (Model-View-ViewModel) architecture, which separates the UI from the business logic and makes the app easier to maintain and test. 

- **Model**: Handles the data and business logic. The data model represents the photo and user information retrieved from the Flickr API.
- **View**: SwiftUI views that render the UI elements and respond to user interactions.
- **ViewModel**: Manages the state of the views, handles user inputs, and interacts with the Model to fetch and update data.

## UI Layout and Design
The app consists of the following screens:

- **Main Screen**: Displays a grid of photos based on the default "Yorkshire" tag. Users can tap on a photo to view more details.
- **Detail Screen**: Provides detailed information about the selected photo, including title, date taken, and associated tags.
- **User Photos Screen**: Displays all photos uploaded by the selected user.

The design follows Apple's Human Interface Guidelines, with a focus on simplicity and ease of use. The app supports both light and dark modes.

## Development Tools and Technologies
- **Swift 5.9**: The programming language used for the app.
- **SwiftUI**: The UI framework used to build the app's interface.
- **Xcode 15**: The development environment used.
- **Flickr API**: The external API used to fetch photo data.

## Installation and Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/photo-explorer.git
   ```
2. Open the project in Xcode:
   ```bash
   open PhotoExplorer.xcodeproj
   ```
3. Build and run the app on the simulator or a physical device.

## Justification of Decisions
- **MVVM Architecture**: Chosen for its clear separation of concerns, which makes the codebase more modular and testable.
- **SwiftUI**: Used for its modern approach to UI development in iOS, which allows for a declarative syntax and easier maintenance.
- **No Third-Party Libraries**: Decided to avoid external dependencies to keep the project lightweight and fully controlled.


## Testing
The app includes unit tests for the ViewModels and data handling logic, ensuring that the business logic works as expected. Additionally, UI tests were implemented to validate user flows and interactions.

- **XCTest**: Used for unit testing.
- **SwiftUI Previews**: Utilized for testing UI components in both light and dark modes.

## Future Improvements
- **Offline Mode**: Implement caching to allow photo browsing even when offline.
- **User Authentication**: Add login functionality to allow users to save favorite photos.
- **Enhanced Search**: Improve the search functionality to support more advanced filtering options.
