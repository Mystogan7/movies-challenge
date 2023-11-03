//
//  Configurations.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 02/11/2023.
//

import Foundation

enum Configuration {
    private static let config: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Configurations", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path) else {
            fatalError("Configurations.plist not found")
        }
        return config
    }()
    
    static var baseURL: String {
        guard let baseURL = Configuration.config["BaseURL"] as? String else {
            fatalError("Invalid or missing BaseURL for configuration")
        }
        return baseURL
    }
    
    static var posterBaseUrl: String {
        guard let baseURL = Configuration.config["PosterBaseURL"] as? String else {
            fatalError("Invalid or missing PosterBaseURL for configuration")
        }
        return baseURL
    }
    
    static var apiKey: String {
        guard let apiKey = Configuration.config["APIKey"] as? String else {
            fatalError("Invalid or missing APIKey for configuration")
        }
        return apiKey
    }
    
    static var accessToken: String {
        guard let apiKey = Configuration.config["AccessToken"] as? String else {
            fatalError("Invalid or missing AccessToken for configuration")
        }
        return apiKey
    }
}
