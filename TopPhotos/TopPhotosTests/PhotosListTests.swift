//
//  PhotosListTests.swift
//  TopPhotosTests
//
//  Created by Emil Zawadzki on 27/10/2023.
//

import XCTest
@testable import TopPhotos

final class PhotosListTests: XCTestCase {
	
	var listPresenter: ListPresenter?

	override func setUpWithError() throws {
		guard let listVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ListVC else {
			return
		}
		listPresenter = ListPresenter(view: listVC)
		listPresenter?.apiConnector = MockedApiConnector()
	}

	override func tearDownWithError() throws {
		
	}

	func testPaginationLogic() throws {
		guard let listPresenter else {
			return
		}
		listPresenter.onViewDidAppear()
		sleep(1)
		
		XCTAssertEqual(listPresenter.photosPage, 1)
		listPresenter.willDisplayCell(index: (listPresenter.numberOfPhotos) - 1)
		XCTAssertEqual(listPresenter.photosPage, 2)
	}
	
	func testTopicsLogic() throws {
		guard let listPresenter else {
			return
		}
		
		listPresenter.onViewDidAppear()
		sleep(1)
		// no filter is selected at the baginning
		XCTAssertNotNil(listPresenter.topics)
		XCTAssertGreaterThan(listPresenter.topics!.count, 1)
		//First topic should be always "All" (generated in the code, not fetched from api)
		XCTAssertEqual(listPresenter.topics!.first!.id, topicAllPicturesID)
	}
	
	func testTopicsChangesLogic() throws {
		guard let listPresenter else {
			return
		}
		listPresenter.onViewDidAppear()
		sleep(1)
		// no filter is selected at the baginning
		XCTAssertNil(listPresenter.selectedTopic)
		// select any filter
		XCTAssertGreaterThan(listPresenter.topics?.count ?? 0, 1)
		listPresenter.filterSelected(filterIndex: 1)
		
		XCTAssertNotNil(listPresenter.selectedTopic)
	}
	
	

}
