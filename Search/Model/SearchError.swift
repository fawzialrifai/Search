//
//  SearchError.swift
//  Search
//
//  Created by Fawzi Rifai on 25/06/2022.
//

enum SearchError: String {
    case urlError = "Invalid URL."
    case connectionError = "Connection Failed."
    case authenticationError = "Authentication Failed."
    case limitError = "Request Limit Exceeded"
    case decodingError = "Displaying Results Failed."
}
