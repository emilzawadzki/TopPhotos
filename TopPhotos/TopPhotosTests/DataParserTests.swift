//
//  DataParserTests.swift
//  TopPhotosTests
//
//  Created by Emil Zawadzki on 26/10/2023.
//

import XCTest
@testable import TopPhotos

final class DataParserTests: XCTestCase {
	
	private let apiConnector = ApiConnector()

	override func setUpWithError() throws {
		
	}

	override func tearDownWithError() throws {
		
	}

	func testParsingTopics() throws {
		let topicsJson = """
		[
			{
				"id": "bo8jQKTaE0Y",
				"slug": "wallpapers",
				"title": "Wallpapers",
				"description": "From epic drone shots to inspiring moments in nature, find free HD wallpapers worthy of your mobile and desktop screens. Finally.",
				"starts_at": "2020-04-15T00:00:00Z",
				"ends_at": null,
				"only_submissions_after": null,
				"visibility": "featured",
				"featured": true,
				"total_photos": 5296,
				"links": {
					"self": "https://api.unsplash.com/topics/wallpapers"
				}
			}
		]
		"""
		let topicsData = topicsJson.data(using: .utf8)
		
		let parsedTopics = apiConnector.parseTopics(from: topicsData)
		
		XCTAssertNotNil(parsedTopics)
		XCTAssertGreaterThan(parsedTopics!.count, 0)
		XCTAssertEqual(parsedTopics?.first?.id, "bo8jQKTaE0Y")
		XCTAssertEqual(parsedTopics?.first?.title, "Wallpapers")
	}
	
	fileprivate let photoJson = """
		{
			"id": "LBI7cgq3pbM",
			"description": "A man drinking a coffee.",
			"user": {
				"id": "pXhwzz1JtQU",
				"username": "poorkane",
				"name": "Gilbert Kane",
			},
			"urls": {
				"raw": "https://images.unsplash.com/face-springmorning.jpg",
				"full": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg",
				"regular": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=1080&fit=max",
				"small": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=400&fit=max"
			}
		}
		"""
	
	func testParsingPhotos() throws {
		let photosArrayJson = "[\(photoJson)]"
		
		let apiConnector = ApiConnector()
		
		let photosArrayData = photosArrayJson.data(using: .utf8)
		let parsedPhotosArray = apiConnector.parsePhotos(from: photosArrayData)
		
		XCTAssertNotNil(parsedPhotosArray)
		XCTAssertGreaterThan(parsedPhotosArray!.count, 0)
		XCTAssertEqual(parsedPhotosArray?.first?.id, "LBI7cgq3pbM")
		XCTAssertEqual(parsedPhotosArray?.first?.smallImagePath, "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=400&fit=max")
		
	}
	
	func testParsingPhotoDetails() throws {
		let apiConnector = ApiConnector()
		
		let photoData = photoJson.data(using: .utf8)
		let parsedPhoto = apiConnector.parsePhotoDetails(from: photoData)
		
		XCTAssertNotNil(parsedPhoto)
		XCTAssertEqual(parsedPhoto?.id, "LBI7cgq3pbM")
		XCTAssertEqual(parsedPhoto?.bigImagePath, "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=1080&fit=max")
		XCTAssertEqual(parsedPhoto?.photoDescription, "A man drinking a coffee.")
		
		XCTAssertNotNil(parsedPhoto?.user)
		XCTAssertEqual(parsedPhoto?.user.id, "pXhwzz1JtQU")
		XCTAssertEqual(parsedPhoto?.user.name, "Gilbert Kane")
	}

}
