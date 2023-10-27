//
//  ApiConnectorProtocol.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 27/10/2023.
//

import Foundation

protocol ApiConnectorProtocol {
	
	func getPhotos(topicID: String?, page: Int, completion: @escaping ([PhotoModel]?, Error?) -> Void)
	
	func getPhotoDetails(id: String, completion: @escaping (PhotoDetailsModel?, Error?) -> Void)
	
	func parsePhotos(from data: Data?) -> [PhotoModel]?
	
	func parsePhotoDetails(from data: Data?) -> PhotoDetailsModel?
	
	func getTopics(completion: @escaping ([TopicModel]?, Error?) -> Void)
	
	func parseTopics(from data: Data?) -> [TopicModel]?
}
