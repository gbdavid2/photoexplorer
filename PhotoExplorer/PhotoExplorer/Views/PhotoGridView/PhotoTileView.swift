import SwiftUI

/// `PhotoTileView` represents a single photo in the grid, displaying the photo's thumbnail and title.
/// This view is designed to be reusable within a grid or list, providing a consistent look and feel for each photo.
struct PhotoTileView: View {
    let photo: PhotoSummary

    var body: some View {
        VStack {
            // Display the photo's thumbnail if available, otherwise show a placeholder.
            if let url = photo.thumbnailURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                        .shadow(color: .gray, radius: 4, x: 0, y: 3)
                } placeholder: {
                    // Placeholder view while the image is loading or if no image URL is available.
                    Color.gray
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                        .shadow(color: .gray, radius: 4, x: 0, y: 3)
                }
            } else {
                // Fallback if there is no URL, showing a gray box instead.
                Color.gray
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 4, x: 0, y: 3)
            }
            
            // Display the photo's title underneath the thumbnail.
            Text(photo.title)
                .font(.caption)
                .lineLimit(1) // Limit the title to a single line to prevent overflow.
                .padding(.top, 4)
        }
    }
}

#Preview {
    VStack {
        // Previewing the PhotoTileView with a sample photo summary.
        PhotoTileView(photo: PhotoSummary(id: "1", title: "Sample Photo", thumbnailURL: URL(string: "https://via.placeholder.com/100")))
        Spacer()
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .padding()
}
