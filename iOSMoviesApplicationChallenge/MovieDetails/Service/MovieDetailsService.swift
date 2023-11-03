//
//  MovieDetailsService.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 03/11/2023.
//

import Foundation

class MovieDetailsService: AsyncCaller {
    typealias T = MovieDetailsResponse
    
    typealias P = Int
        
    private let client: NetworkClientProtocol
    
    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }
    
    func call(with parameters: P, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = MoviesAPI.Endpoint.movieDetails(id: parameters).url() else {
            completion(.failure(NetworkError.invalidURL("Invalid moviesDetails url.")))
            return
        }
        
        self.client.request(url, completion: completion)
    }
}
