//
//  MoviesListViewModelTests.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 02/11/2023.
//

import XCTest
@testable import iOSMoviesApplicationChallenge

class MoviesListViewModelTests: XCTestCase {

    var sut: MoviesListViewModel<MockMoviesService>!
    var mockService: MockMoviesService!

    override func setUp() {
        super.setUp()
        mockService = MockMoviesService()
        sut = MoviesListViewModel(service: mockService)
    }

    override func tearDown() {
        mockService = nil
        sut = nil
        super.tearDown()
    }

    func testFetchMoviesSuccess() {
        // Given
        let movies = [
            Movie(id: 1, overview: "Overview1", posterPath: "/path1", releaseDate: "2021-11-01", title: "TestMovie1", voteAverage: 8.0),
            Movie(id: 2, overview: "Overview2", posterPath: "/path2", releaseDate: "2021-11-01", title: "TestMovie2", voteAverage: 7.0)
        ]

        let expectedResponse = MoviesListResponse(page: 1, results: movies)
        mockService.response = expectedResponse

        let fetchExpectation = expectation(description: "fetchMovies success")
        sut.onFetchSuccess = { [weak self] _ in
            XCTAssertEqual(expectedResponse.results[0], self?.sut.movie(atIndex: 0))
            XCTAssertEqual(self?.sut.currentCount(), movies.count)
            fetchExpectation.fulfill()
        }

        // When
        sut.fetchMovies()

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testFetchMoviesFailure() {
        // Given
        let expectedError = NSError(domain: "TestError", code: 999, userInfo: nil)
        mockService.error = expectedError

        let fetchExpectation = expectation(description: "fetchMovies failure")
        sut.onFetchFailure = { error in
            XCTAssertEqual(error as NSError, expectedError)
            fetchExpectation.fulfill()
        }

        // When
        sut.fetchMovies()

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

class MockMoviesService: AsyncCaller {
    typealias T = MoviesListResponse
    typealias P = Int

    var response: MoviesListResponse?
    var error: Error?

    func call(with parameter: P, completion: @escaping (Result<T, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else if let response = response {
            completion(.success(response))
        }
    }
}
