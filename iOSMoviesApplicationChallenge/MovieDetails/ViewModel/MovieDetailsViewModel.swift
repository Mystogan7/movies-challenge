//
//  MovieDetailsViewModel.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 03/11/2023.
//

import Foundation

protocol MovieDetailsViewModelProtocol {
    var onFetchSuccess: (MovieDetailsResponse) -> Void { get set }
    var onFetchFailure: (Error) -> Void { get set }
    
    func fetchDetails(for movieId: Int)
}

class MovieDetailsViewModel<Service: AsyncCaller>: MovieDetailsViewModelProtocol where Service.T == MovieDetailsResponse, Service.P == Int {
    
    var onFetchSuccess: (MovieDetailsResponse) -> Void = { _ in }
    var onFetchFailure: (Error) -> Void = { _ in }
    
    private let service: Service
    
    init(service: Service = MovieDetailsService()) {
        self.service = service
    }
    
    func fetchDetails(for movieId: Int) {
        service.call(with: movieId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieDetailsResponse):
                self.onFetchSuccess(movieDetailsResponse)
            case .failure(let error):
                self.onFetchFailure(error)
            }
        }
    }
}
