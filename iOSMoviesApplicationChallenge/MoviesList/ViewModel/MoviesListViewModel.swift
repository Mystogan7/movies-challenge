//
//  MoviesListViewModel.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 03/11/2023.
//

import Foundation

protocol MoviesListViewModelProtocol {
    var onFetchSuccess: (([IndexPath]?) -> Void) { get set }
    var onFetchFailure: ((Error) -> Void) { get set }
    
    func fetchMovies()
    func currentCount() -> Int
    func movie(atIndex index: Int) -> Movie?
}

class MoviesListViewModel<Service: AsyncCaller>: MoviesListViewModelProtocol where Service.T == MoviesListResponse, Service.P == Int {
    
    private var movies: [Movie] = []
    private var currentPage: Int = 0
    private let service: Service

    private var isFetching: Bool = false

    var onFetchSuccess: (([IndexPath]?) -> Void) = { _ in }
    var onFetchFailure: ((Error) -> Void) = { _ in }

    init(service: Service = MoviesListService()) {
        self.service = service
    }

    func currentCount() -> Int {
        return movies.count
    }

    func movie(atIndex index: Int) -> Movie? {
        guard index < movies.count else { return nil }
        return movies[index]
    }

    func fetchMovies() {
        guard !isFetching else { return }

        isFetching = true
        let nextPage = currentPage + 1
        
        service.call(with: nextPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieListResponse):
                self.currentPage = movieListResponse.page
                self.movies.append(contentsOf: movieListResponse.results)
                
                if self.currentPage > 1 {
                  let indexPathsToReload = self.calculateIndexPathsToReload(from: movieListResponse.results)
                    self.onFetchSuccess(indexPathsToReload)
                } else {
                    self.onFetchSuccess(nil)
                }
            case .failure(let error):
                self.onFetchFailure(error)
            }
            self.isFetching = false
        }
    }
    
    private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
      let startIndex = movies.count - newMovies.count
      let endIndex = startIndex + newMovies.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
