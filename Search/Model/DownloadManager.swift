//
//  DownloadManager.swift
//  Search
//
//  Created by Fawzi Rifai on 25/06/2022.
//

import Foundation

@MainActor class DownloadManager: ObservableObject {
    @Published var data: Data?
    init(url: URL?) {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}
