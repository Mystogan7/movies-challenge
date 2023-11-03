//
//  MoviesUITests.swift
//  MoviesUITests
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 02/11/2023.
//

import XCTest

final class MoviesApplicationUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.launch()
        continueAfterFailure = false
    }
    
    func testDisplayMoviesInList() {
        let firstCell = app.tables.cells.firstMatch
        XCTAssertTrue(firstCell.exists)
    }

    func testNavigationToMovieDetails() {
        let firstCell = app.tables.cells.firstMatch
        firstCell.tap()
        
        let movieDetailsView = app.otherElements["movieDetails"]
        XCTAssertTrue(movieDetailsView.exists)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
    }
}
