//
//  Photo.swift
//  Search
//
//  Created by Fawzi Rifai on 25/06/2022.
//

import UIKit

struct Photo: Codable {
    let id: String
    let created_at: Date
    let description: String?
    let width: Double
    let height: Double
    let exif: Camera?
    let user: User
    let urls: URLS
    static var example = Photo(id: UUID().uuidString, created_at: Date(), description: "This is an examble photo.", width: 100, height: 100, exif: .example, user: .example, urls: .example)
}

extension Photo {
    struct Camera: Codable {
        let make: String
        let model: String
        static var example = Camera(make: "Canon", model: "Canon EOS 40D")
    }
    struct User: Codable {
        let username: String
        let name: String
        let portfolio_url: String?
        var portfolioUrl: URL? {
            if let urlString = portfolio_url {
                return URL(string: urlString)
            } else {
                return nil
            }
        }
        static var example = User(username: "fawzialrifai", name: "Fawzi Rifai", portfolio_url: "https://www.github.com/fawzialrifai")
    }
    struct URLS: Codable {
        let small: String
        var smallURL: URL? { URL(string: small) }
        let full: String
        var fullURL: URL? { URL(string: full) }
        static var example = URLS(small: "https://images.unsplash.com/photo-1416339306562-f3d12fefd36f?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=8aae34cf35df31a592f0bef16e6342ef", full: "https://images.unsplash.com/photo-1416339306562-f3d12fefd36f")
    }
}
