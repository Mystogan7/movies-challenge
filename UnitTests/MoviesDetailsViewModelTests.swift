//
//  MoviesDetailsViewModelTests.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 03/11/2023.
//

import XCTest

final class MoviesDetailsViewModelTests: XCTestCase {
    var sut = MoviesDetailsViewModelTestsProtocol
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MoviesDetailsViewModelTests()
    }
    
    func testFetchMovieDetailsSuccess() {
        let expection = expectation(description: "Movie details are fetched successfully")
        
        sut.onFetchSuccess = {
            expection.fulfill()
        }
        
        sut.fetchDetails()
        
        wait(for: [expection], timeout: 0.5)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

}
