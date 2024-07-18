//
//  MovieModel.swift
//  MovieSearchApp
//
//  Created by Amit Sharma on 17/07/24.
//

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String?
    let overview: String?
    let voteAverage: Double?
    let credits: Credits?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case overview
        case voteAverage = "vote_average"
        case credits
    }
}

struct Credits: Codable {
    let cast: [CastMember]
}

struct CastMember: Codable {
    let name: String
}

struct APIResponse: Codable {
    let results: [Movie]
}
