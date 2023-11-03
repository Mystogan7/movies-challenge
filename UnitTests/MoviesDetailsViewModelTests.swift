//
//  MoviesDetailsViewModelTests.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 03/11/2023.
//

import XCTest
@testable import iOSMoviesApplicationChallenge

class MoviesDetailsViewModelTests: XCTestCase {

    var sut: MovieDetailsViewModel<MockDetailsService>!
    var mockService: MockDetailsService!

    override func setUp() {
        super.setUp()
        mockService = MockDetailsService()
        sut = MovieDetailsViewModel(service: mockService)
    }

    override func tearDown() {
        mockService = nil
        sut = nil
        super.tearDown()
    }

    func testFetchDetailsSuccess() {
        // Given
        let expectedResponse = MovieDetailsResponse(genres: [Genre(id: 1, name: "action")], overview: "overview", posterPath: "/path", releaseDate: "1993-11-08", title: "TestMovie", voteAverage: 8.0)

        mockService.response = expectedResponse

        let fetchExpectation = expectation(description: "fetch movie details success")
        sut.onFetchSuccess = { details in
            XCTAssertEqual(expectedResponse, details)
            fetchExpectation.fulfill()
        }

        // When
        sut.fetchDetails(for: 1)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testFetchDetailsFailure() {
        // Given
        let expectedError = NSError(domain: "TestError", code: 999, userInfo: nil)
        mockService.error = expectedError

        let fetchExpectation = expectation(description: "fetch movie details failure")
        sut.onFetchFailure = { error in
            XCTAssertEqual(error as NSError, expectedError)
            fetchExpectation.fulfill()
        }

        // When
        sut.fetchDetails(for: 1)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

class MockDetailsService: AsyncCaller {
    typealias T = MovieDetailsResponse
    typealias P = Int

    var response: MovieDetailsResponse?
    var error: Error?

    func call(with parameter: P, completion: @escaping (Result<T, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else if let response = response {
            completion(.success(response))
        }
    }
}
