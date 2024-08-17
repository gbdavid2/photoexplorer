//
//  PhotoService.swift
//  PhotoExplorer
//
//  Created by David Garces on 16/08/2024.
//

import Foundation

struct PhotoService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = URLSessionClient()) {
        self.networkClient = networkClient
    }
    
//    func fetchPhoto(by id: String) async throws -> FlickrPhotoDetail {
//        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=YOUR_API_KEY&photo_id=\(id)&format=json&nojsoncallback=1")!
//        let data = try await networkClient.fetchData(from: url)
//        let photoDetailResponse = try JSONDecoder().decode(FlickrPhotoDetailResponse.self, from: data)
//        return photoDetailResponse.photo
//    }
}
