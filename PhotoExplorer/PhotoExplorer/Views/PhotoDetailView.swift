//
//  PhotoDetailView.swift
//  PhotoExplorer
//
//  Created by David Garces on 18/08/2024.
//

import SwiftUI

/// `PhotoDetailView` displays the detailed information of a selected photo in a card-like view.
/// The card adjusts its height based on the content but ensures it covers a reasonable portion of the screen.
struct PhotoDetailView: View {
    let photoDetail: PhotoDetail
    let onClose: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                // Image at the top of the card
                if let imageURL = photoDetail.imageURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 10,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 10
                                )
                            )
                    } placeholder: {
                        ProgressView()
                    }
                }

                // Photo title
                Text(photoDetail.title)
                    .font(.headline)
                    .padding([.top, .horizontal])

                // Owner
                Text("By \(photoDetail.owner)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                // First Separator
                Divider()
                    .padding(.horizontal)

                // Photo description
                Text(photoDetail.description)
                    .font(.body)
                    .padding(.horizontal)

                // Second Separator
                Divider()
                    .padding(.horizontal)

                // Date taken
                Text("Taken on: \(photoDetail.dateTaken)")
                    .font(.subheadline)
                    .padding([.bottom, .horizontal])

                Spacer()
            }
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding()
            .frame(minHeight: 300)
            .frame(maxHeight: .infinity, alignment: .top)

            // Close button
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding()
            }
            .offset(x: -10, y: 10)
        }
        .transition(.move(edge: .bottom))
        .animation(.spring(), value: photoDetail)
    }
}

#Preview {
    // Creating a sample `PhotoDetail` for the preview
    let sampleDetail = PhotoDetail(
        id: "12345",
        title: "Sample Photo Title",
        description: "This is a sample description for the photo. It provides more context and background about the photo, explaining what the viewer is seeing.",
        owner: "John Doe",
        dateTaken: "2024-08-20 12:34:56",
        imageURL: URL(string: "https://via.placeholder.com/400")
    )

    // Previewing the `PhotoDetailView` with the sample data
    PhotoDetailView(photoDetail: sampleDetail) {
        // Action to perform when the close button is tapped (no-op for preview)
    }
}

#Preview {
    // Creating a sample `PhotoDetail` for the preview
    let sampleDetail = PhotoDetail(
        id: "12345",
        title: "Sample Photo Title",
        description: "This is a sample description for the photo. It provides more context and background about the photo, explaining what the viewer is seeing.",
        owner: "John Doe",
        dateTaken: "2024-08-20 12:34:56",
        imageURL: URL(string: "https://via.placeholder.com/400")
    )

    // Previewing the `PhotoDetailView` with the sample data
    PhotoDetailView(photoDetail: sampleDetail) {
        // Action to perform when the close button is tapped (no-op for preview)
    }
    .preferredColorScheme(.dark)
}
