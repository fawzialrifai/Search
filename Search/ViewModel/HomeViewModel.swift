//
//  HomeViewModel.swift
//  Search
//
//  Created by Fawzi Rifai on 25/06/2022.
//

import Foundation

@MainActor class HomeViewModel: ObservableObject {
    @Published var photos = [Photo]()
    @Published var query = ""
    @Published var isResultsPresented = false
    var url: URL? {
        let accessKey = "YDGu7GdDGVgfbIy7POPO2bqwwZ95phdMkCJ2MZAkbkA"
        let baseURL = "https://api.unsplash.com/photos/random"
        let count = 30
        return URL(string: "\(baseURL)?client_id=\(accessKey)&count=\(count)")
    }
    
    init() {
        fetchRandomPhotos()
    }
    
    func fetchRandomPhotos() {
        guard let queryUrl = url else { return }
        URLSession.shared.dataTask(with: queryUrl) { data, _, _ in
            DispatchQueue.main.async {
                guard let encodedPhotos = data else { return }
                if let decodedPhotos = try? JSONDecoder().decode([Photo].self, from: encodedPhotos) {
                    self.photos.append(contentsOf: decodedPhotos)
                }
            }
        }.resume()
    }
    
    func fetchMorePhotos(currentPhoto: Photo) {
        if let index = photos.firstIndex(where: { $0.id == currentPhoto.id }) {
            if photos.count - index == 15 {
                fetchRandomPhotos()
            }
        }
    }
    
    func submitQuery() {
        if !query.isTotallyEmpty {
            isResultsPresented = true
        }
    }
}
