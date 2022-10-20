//
//  ViewModelsTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 05/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

class ViewModelsTests: XCTestCase {

    func test_MovieViewModel() throws {
        var movieData = Data()
        movieData = try Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "Movie", withExtension: "json")!)
        
        let decoder = jsonDecoder()
        var movie = Movie()
        movie = try decoder.decode(Movie.self, from: movieData)
        
        let viewModel = MovieViewModel(movie: movie)
        
        XCTAssertEqual(viewModel.id, 155)
        XCTAssertEqual(viewModel.title, "The Dark Knight")
        XCTAssertEqual(viewModel.isRatingAvailable, true)
        XCTAssertEqual(viewModel.ratingString, "85")
        XCTAssertEqual(viewModel.percentRating, 85)
        XCTAssertEqual(viewModel.genres(), "Drama, Action, Crime, Thriller")
        XCTAssertEqual(viewModel.runtime, "2h 32m")
        XCTAssertEqual(viewModel.releaseYear, "2008")
        XCTAssertEqual(viewModel.releaseDateWithoutYear, "Jul 14")
        XCTAssertEqual(viewModel.cast.count, 134)
        XCTAssertEqual(viewModel.crew.count, 112)
        XCTAssertEqual(viewModel.recommendedMovies.count, 21)
        XCTAssertEqual(viewModel.topCast.count, 8)
        XCTAssertEqual(viewModel.topCrew.count, 8)
        XCTAssertEqual(viewModel.videos.count, 7)
        XCTAssertEqual(viewModel.infoArray.count, 6)
    }

    func test_PersonViewModel() throws {
        var personData = Data()
        personData = try Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "Person", withExtension: "json")!)
        
        let decoder = jsonDecoder()
        var person = Person()
        person = try decoder.decode(Person.self, from: personData)
        
        let viewModel = PersonViewModel(person: person)
        
        XCTAssertEqual(viewModel.id, 10859)
        XCTAssertEqual(viewModel.name, "Ryan Reynolds")
        XCTAssertEqual(viewModel.popularMovies.count, 8)
        XCTAssertEqual(viewModel.castCredits.count, 84)
        XCTAssertEqual(viewModel.crewCredits.count, 18)
    }
}
