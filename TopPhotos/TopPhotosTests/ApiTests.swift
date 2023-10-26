//
//  ApiTests.swift
//  ApiTests
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import XCTest
@testable import TopPhotos

final class ApiTests: XCTestCase {
	
	private let apiConnector = ApiConnector()
	private let asyncTimeout = 10.0

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

	func testFetchingPhotos() async throws {
		
		let expectation = XCTestExpectation(description: "Photos fetch ended")
		
		apiConnector.getPhotos(completion: { photos, error in
			XCTAssertNotNil(photos)
			XCTAssertGreaterThan(photos!.count, 0)
			expectation.fulfill()
		})
		
		wait(for: [expectation], timeout: asyncTimeout)
	}
	
	func testFetchingTopics() async throws {
		
		let expectation = XCTestExpectation(description: "Topics fetch ended")
		
		apiConnector.getTopics(completion: { topics, error in
			XCTAssertNotNil(topics)
			XCTAssertGreaterThan(topics!.count, 0)
			expectation.fulfill()
		})
		
		wait(for: [expectation], timeout: asyncTimeout)
	}
	
	func testFetchingPhotoDetails() async throws {
		
		let expectation = XCTestExpectation(description: "Photo details fetch ended")
		
		apiConnector.getPhotoDetails(id: "2Eewt6DoSRI", completion: { photoDetails, error in
			XCTAssertNotNil(photoDetails)
			XCTAssertNotNil(photoDetails?.id)
			XCTAssertNotNil(photoDetails?.bigImagePath)
			expectation.fulfill()
		})
		
		wait(for: [expectation], timeout: asyncTimeout)
	}
	
}
