//
//  Movie.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import Foundation

struct Movie: Codable {
    let uuid = UUID()
    
    let id: String
    let title: String?
    let year: String?
    let poster: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
    }
}

extension Movie: Hashable {
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
