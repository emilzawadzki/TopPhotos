//
//  MockedApiConnector.swift
//  TopPhotosTests
//
//  Created by Emil Zawadzki on 27/10/2023.
//

import Foundation
@testable import TopPhotos

class MockedApiConnector: ApiConnectorProtocol {
	
	func getPhotos(topicID: String?, page: Int, completion: @escaping ([TopPhotos.PhotoModel]?, TopPhotosError?) -> Void) {
		var photos = [TopPhotos.PhotoModel]()
		photos.append(PhotoModel(id: "id1", urls: ["small" : "link1"]))
		photos.append(PhotoModel(id: "id2", urls: ["small" : "link2"]))
		completion(photos, nil)
	}
	
	func getPhotoDetails(id: String, completion: @escaping (TopPhotos.PhotoDetailsModel?, TopPhotosError?) -> Void) {
		let user = UserModel(id: "userId1", name: "User 1")
		let details = PhotoDetailsModel(id: "id1", description: "desc1", alt_description: "alt_desc1", urls: ["regular" : "link1"], user: user)
		completion(details, nil)
	}
	
	func getTopics(completion: @escaping ([TopPhotos.TopicModel]?, TopPhotosError?) -> Void) {
		var topics = [TopPhotos.TopicModel]()
		topics.append(TopicModel(id: "id1", title: "Topic1"))
		topics.append(TopicModel(id: "id2", title: "Topic2"))
		completion(topics, nil)
	}
	
	func parsePhotos(from data: Data?) -> [TopPhotos.PhotoModel]? {
		return nil
	}
	
	func parsePhotoDetails(from data: Data?) -> TopPhotos.PhotoDetailsModel? {
		return nil
	}
	
	func parseTopics(from data: Data?) -> [TopPhotos.TopicModel]? {
		return nil
	}
	
	
}
