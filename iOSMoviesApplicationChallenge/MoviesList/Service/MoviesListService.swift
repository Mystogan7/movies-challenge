//
//  MoviesListService.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 03/11/2023.
//

import Foundation

class MoviesListService: AsyncCaller {
    typealias P = Int
    
    typealias T = MoviesListResponse
    
    private let client: NetworkClientProtocol
    
    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }
    
    func call(with parameters: P, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = MoviesAPI.Endpoint.moviesList(page: parameters).url() else {
            completion(.failure(NetworkError.invalidURL("Invalid moviesList url.")))
            return
        }
        
        self.client.request(url, completion: completion)
    }
}
