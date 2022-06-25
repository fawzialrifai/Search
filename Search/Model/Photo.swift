//
//  Photo.swift
//  Search
//
//  Created by Fawzi Rifai on 25/06/2022.
//

import UIKit

struct Photo: Codable {
    let id: String
    let description: String?
    let user: User
    let urls: URLS
    static var example = Photo(id: UUID().uuidString, description: "This is an examble photo.", user: .example, urls: .example)
}

extension Photo {
    struct User: Codable {
        let name: String
        let portfolio_url: String?
        var portfolioUrl: URL? {
            if let urlString = portfolio_url {
                return URL(string: urlString)
            } else {
                return nil
            }
        }
        static var example = User(name: "Fawzi Rifai", portfolio_url: "https://www.github.com/fawzialrifai")
    }
    struct URLS: Codable {
        let thumb: String
        var thumbUrl: URL? { URL(string: thumb) }
        static var example = URLS(thumb: "https://images.unsplash.com/photo-1579353977828-2a4eab540b9a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1374&q=80")
    }
}
