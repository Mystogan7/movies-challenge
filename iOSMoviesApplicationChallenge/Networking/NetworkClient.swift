//
//  NetworkClient.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 02/11/2023.
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(_ url: URL, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared, urlCache: URLCache? = nil) {
        self.session = session
        
        if let cache = urlCache {
            self.session.configuration.urlCache = cache
        } else {
            let memoryCapacity = 500 * 1024 * 1024
            let diskCapacity = 500 * 1024 * 1024
            let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "dataCache")
            self.session.configuration.urlCache = cache
        }
    }
    
    func request<T: Decodable>(_ url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(MoviesAPI.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode else {
                completion(.failure(NetworkError.statusCode))
                return
            }
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(NetworkError.decoding))
                }
            } else if let error = error {
                completion(.failure(NetworkError.network(error)))
            } else {
                completion(.failure(NetworkError.network(nil)))
            }
        }.resume()
    }
}

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return (200...299).contains(statusCode)
    }
}

enum NetworkError: Error {
    case network(Error?)
    case decoding
    case statusCode
    case invalidURL(String)
    
    var reason: String {
        switch self {
        case .network(let underlyingError):
            if let error = underlyingError {
                return "An error occurred while fetching data: \(error.localizedDescription)"
            }
            return "An error occurred while fetching data."
            
        case .decoding:
            return "An error occurred while decoding data."
            
        case .statusCode:
            return "Received an unsuccessful response"
            
        case .invalidURL(let url):
            return "An error occured while handling the url:\(url)"
        }
    }
}

