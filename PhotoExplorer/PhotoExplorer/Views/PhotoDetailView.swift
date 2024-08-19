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
                                .font(.title2)
                                .padding(6)
                                .background(Color(.systemBackground).opacity(0.7))
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .offset(x: -10, y: 10)
                        .accessibilityLabel("Close Detail View")
        }
    }
}

#Preview {
    // Previewing the `PhotoDetailView` with the sample data
    PhotoDetailView(photoDetail: PhotoDetail.sample) {
        // Action to perform when the close button is tapped (no-op for preview)
    }
}

#Preview {
    // Previewing the `PhotoDetailView` with the sample data
    PhotoDetailView(photoDetail: PhotoDetail.sample) {
        // Action to perform when the close button is tapped (no-op for preview)
    }
    .preferredColorScheme(.dark)
}
