//
//  MovieDetailsResponse.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 03/11/2023.
//

import Foundation

struct MovieDetailsResponse: Codable {
    let backdropPath: String
    let genres: [Genre]
    let overview: String
    let releaseDate: String
    let title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case genres
        case backdropPath = "backdrop_path"
        case overview
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}

struct Genre: Codable, Equatable {
    let id: Int
    let name: String
}
