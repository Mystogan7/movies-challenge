//
//  MoviesListViewModelTests.swift
//  MoviesListViewModelTests
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 02/11/2023.
//

import XCTest
@testable import iOSMoviesApplicationChallenge

final class MoviesListViewModelTests: XCTestCase {
    var sut: MoviesListViewModelProtocol
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MoviesListViewModel()
    }
    
    func testFetchMoviesSuccess() {
        let expection = expectation(description: "Trending movies are fetched successfully")
        
        sut.onFetchSuccess = {
            expection.fulfill()
        }
        
        sut.fetchMovies()
        
        wait(for: [expection], timeout: 0.5)
    }
    
    func testSelectMovie() {
        sut.fetchMovies()
        
        sut.selectMovie(atIndex: 0)
        
        XCTAssertNotNil(viewModel.navigateToMovieDetails)
    }


    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
}
