//
//  ResultsViewModel.swift
//  Search
//
//  Created by Fawzi Rifai on 25/06/2022.
//

import Foundation

@MainActor class ResultsViewModel: ObservableObject {
    let query: String
    var currentPage = 1
    var queryURL: URL? {
        let accessKey = "YDGu7GdDGVgfbIy7POPO2bqwwZ95phdMkCJ2MZAkbkA"
        let baseURL = "https://api.unsplash.com/search/photos"
        let count = 30
        let validQuery = query.replacingOccurrences(of: " ", with: "-")
        return URL(string: "\(baseURL)?client_id=\(accessKey)&page=\(currentPage)&per_page=\(count)&query=\(validQuery)")
    }
    @Published var isFetching = false
    @Published var photos = [Photo]()
    @Published var error: SearchError? = nil
    
    init(query: String) {
        self.query = query
        fetchResults()
    }
    
    func fetchResults() {
        guard let queryUrl = queryURL else {
            error = .urlError
            return
        }
        error = nil
        isFetching = true
        URLSession.shared.dataTask(with: queryUrl) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    self.error = .connectionError
                } else if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        guard let data = data else { return }
                        if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                            self.photos.append(contentsOf: decodedResponse.results)
                        } else {
                            self.error = .decodingError
                        }
                    } else if response.statusCode == 401 {
                        self.error = .authenticationError
                    } else if response.statusCode == 403 {
                        self.error = .limitError
                    }
                }
                self.isFetching = false
            }
        }.resume()
    }
    
    func fetchMorePhotos(currentPhoto: Photo) {
        if let index = photos.firstIndex(where: { $0.id == currentPhoto.id }) {
            if photos.count - index == 15 {
                currentPage += 1
                guard let queryUrl = queryURL else { return }
                URLSession.shared.dataTask(with: queryUrl) { data, _, _ in
                    DispatchQueue.main.async {
                        guard let data = data else { return }
                        if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                            self.photos.append(contentsOf: decodedResponse.results)
                        }
                        
                    }
                }.resume()
            }
        }
    }
}
