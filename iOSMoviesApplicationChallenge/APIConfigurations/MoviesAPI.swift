//
//  MoviesAPI.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 02/11/2023.
//

import Foundation

struct MoviesAPI {
    static let baseURL = Configuration.baseURL
    static let posterBaseURL = Configuration.posterBaseUrl
    static let apiKey = Configuration.apiKey
    static let accessToken = Configuration.accessToken
    
    enum Endpoint {
        case moviesList
        case movieDetails(id: Int)
        case moviePoster(path: String)
    }
}

extension MoviesAPI.Endpoint {
    func url() -> URL? {
        var components: URLComponents!
        
        switch self {
        case .moviesList:
            components = URLComponents(string: MoviesAPI.baseURL)
            components?.path += "/discover"
        case .movieDetails(let id):
            components = URLComponents(string: MoviesAPI.baseURL)
            components?.path += "/movie/\(id)"
        case .moviePoster(let path):
            components = URLComponents(string: MoviesAPI.posterBaseURL)
            components?.path += "/\(path)"
        }
        
        return components?.url
    }
}
