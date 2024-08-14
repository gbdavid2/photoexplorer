//
//  ContentView.swift
//  PhotoExplorer
//
//  Created by David Garces on 14/08/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var showDetail: Bool = false
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            
            if showDetail {
                // TODO: Show detail instead of main content
                content
            } else {
                content
                    .background(
                        Image(Constants.blob1)
                            .offset(x: Constants.blobOffsetX, y: Constants.blobOffsetY)
                            .accessibility(hidden: true)
                    )
            }
            
            
        }
    }
    
    var content: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
    
    enum Constants {
        static var blob1 = "Blob"
        static var blobOffsetX = CGFloat(-100)
        static var blobOffsetY = CGFloat(-400)
    }
}



#Preview {
    ContentView()

}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}

