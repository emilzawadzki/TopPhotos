//
//  ApiConnectorProtocol.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 27/10/2023.
//

import Foundation

protocol ApiConnectorProtocol {
	
	func getPhotos(topicID: String?, page: Int, completion: @escaping ([PhotoModel]?, TopPhotosError?) -> Void)
	
	func getPhotoDetails(id: String, completion: @escaping (PhotoDetailsModel?, TopPhotosError?) -> Void)
	
	func getTopics(completion: @escaping ([TopicModel]?, TopPhotosError?) -> Void)
	
	func parsePhotos(from data: Data?) -> [PhotoModel]?
	
	func parsePhotoDetails(from data: Data?) -> PhotoDetailsModel?
	
	func parseTopics(from data: Data?) -> [TopicModel]?
}
