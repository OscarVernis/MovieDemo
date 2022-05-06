//
//  XCTestCase+AwaitPublisher.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 22/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

//MARK: - Models
extension XCTestCase {
    func anyMovie() -> Movie {
        var movieData = Data()
        XCTAssertNoThrow( movieData = try Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "Movie", withExtension: "json")!) )
        
        let decoder = jsonDecoder()
        var movie = Movie()
        XCTAssertNoThrow( movie = try decoder.decode(Movie.self, from: movieData) )
        
        return movie
    }
    
    func anyMovieVM() -> MovieViewModel {
        return MovieViewModel(movie: anyMovie())
    }
    
    func anyPerson() -> Person {
        var personData = Data()
        XCTAssertNoThrow( personData = try Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "Person", withExtension: "json")!) )
        
        let decoder = jsonDecoder()
        var person = Person()
        XCTAssertNoThrow( person = try decoder.decode(Person.self, from: personData) )
        
        return person
    }
    
    func anyPersonVM() -> PersonViewModel {
        return PersonViewModel(person: anyPerson())
    }
    
    func anyMovies(count: Int) -> [Movie] {
        var movies = [Movie]()
        
        for _ in 0..<count {
            movies.append(anyMovie())
        }
        
        return movies
    }
    
    func anyPersons(count: Int) -> [Person] {
        var person = [Person]()
        
        for _ in 0..<count {
            person.append(anyPerson())
        }
        
        return person
    }
    
}

//MARK: - Helpers
extension XCTestCase {
    func jsonDecoder(dateFormat: String = "yyyy-MM-dd", keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }
    
    func wait(for delay: Double) {
        let exp = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { exp.fulfill() }
        wait(for: [exp], timeout: delay)
    }
    
}

//MARK: - Combine
import Combine

//Source: https://www.swiftbysundell.com/articles/unit-testing-combine-based-swift-code/
extension XCTestCase {
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )

        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }
    
}

//MARK: - ViewController Deallocation

//Source: https://www.avanderlee.com/swift/memory-leaks-unit-tests/
extension XCTestCase {
    /// Verifies whether the given constructed UIViewController gets deallocated after being presented and dismissed.
    ///
    /// - Parameter testingViewController: The view controller constructor to use for creating the view controller.
    func assertDeallocation(of testedViewController: () -> UIViewController) {
        weak var weakReferenceViewController: UIViewController?

        let autoreleasepoolExpectation = expectation(description: "Autoreleasepool should drain")
        autoreleasepool {
            let rootViewController = UIViewController()

            // Make sure that the view is active and we can use it for presenting views.
            let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()

            /// Present and dismiss the view after which the view controller should be released.
            rootViewController.present(testedViewController(), animated: false, completion: {
                weakReferenceViewController = rootViewController.presentedViewController
                XCTAssertNotNil(weakReferenceViewController)

                rootViewController.dismiss(animated: false, completion: {
                    autoreleasepoolExpectation.fulfill()
                })
            })
        }
        wait(for: [autoreleasepoolExpectation], timeout: 10.0)
        wait(for: weakReferenceViewController == nil, timeout: 3.0, description: "The view controller should be deallocated since no strong reference points to it.")
    }

    /// Checks for the callback to be the expected value within the given timeout.
    ///
    /// - Parameters:
    ///   - condition: The condition to check for.
    ///   - timeout: The timeout in which the callback should return true.
    ///   - description: A string to display in the test log for this expectation, to help diagnose failures.
    func wait(for condition: @autoclosure @escaping () -> Bool, timeout: TimeInterval, description: String, file: StaticString = #file, line: UInt = #line) {
        let end = Date().addingTimeInterval(timeout)

        var value: Bool = false
        let closure: () -> Void = {
            value = condition()
        }

        while !value && 0 < end.timeIntervalSinceNow {
            if RunLoop.current.run(mode: RunLoop.Mode.default, before: Date(timeIntervalSinceNow: 0.002)) {
                Thread.sleep(forTimeInterval: 0.002)
            }
            closure()
        }

        closure()

        XCTAssertTrue(value, "➡️? Timed out waiting for condition to be true: \"\(description)\"", file: file, line: line)
    }
}
