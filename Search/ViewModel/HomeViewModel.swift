//
//  HomeViewModel.swift
//  Search
//
//  Created by Fawzi Rifai on 25/06/2022.
//

import Foundation

@MainActor class HomeViewModel: ObservableObject {
    var recentSearches = [String]() {
        willSet {
            objectWillChange.send()
        }
        didSet {
            UserDefaults.standard.setValue(recentSearches, forKey: "Recents")
        }
    }
    @Published var isClearAllRecentsPresented = false
    @Published var randomPhotos = [Photo]()
    @Published var query = ""
    @Published var isQueryResultsPresented = false
    var url: URL? {
        let accessKey = "YDGu7GdDGVgfbIy7POPO2bqwwZ95phdMkCJ2MZAkbkA"
        let baseURL = "https://api.unsplash.com/photos/random"
        let count = 30
        return URL(string: "\(baseURL)?client_id=\(accessKey)&count=\(count)")
    }
    
    init() {
        recentSearches = UserDefaults.standard.array(forKey: "Recents") as? [String] ?? []
        fetchRandomPhotos()
    }
    
    func fetchRandomPhotos() {
        guard let queryUrl = url else { return }
        URLSession.shared.dataTask(with: queryUrl) { data, _, _ in
            DispatchQueue.main.async {
                guard let encodedPhotos = data else { return }
                if let decodedPhotos = try? JSONDecoder().decode([Photo].self, from: encodedPhotos) {
                    self.randomPhotos.append(contentsOf: decodedPhotos)
                }
            }
        }.resume()
    }
    
    func fetchMorePhotos(currentPhoto: Photo) {
        if let index = randomPhotos.firstIndex(where: { $0.id == currentPhoto.id }) {
            if randomPhotos.count - index == 15 {
                fetchRandomPhotos()
            }
        }
    }
    
    func search(for query: String) {
        if !query.isTotallyEmpty {
            isQueryResultsPresented = true
            if !recentSearches.contains(query.trimmed) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.recentSearches.append(query.trimmed)
                }
            }
        }
    }
    
    func deleteFromRecents(_ query: String) {
        if let index = recentSearches.firstIndex(of: query) {
            recentSearches.remove(at: index)
        }
    }
}
