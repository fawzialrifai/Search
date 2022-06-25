//
//  String-extension.swift
//  Search
//
//  Created by Fawzi Rifai on 25/06/2022.
//

extension String {
    var isTotallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
