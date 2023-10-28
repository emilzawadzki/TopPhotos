//
//  ApiConnector.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import Foundation


class ApiConnector: ApiConnectorProtocol {
	
	private var session = URLSession.shared
	private let apiKey = "4KQGrzmAvcI8GrnEDmFN29d67zIcT3cW0H2gSjyrXek"
	private let apiPath = "https://api.unsplash.com/"
	private let photosPerPage = 50
	private let topicsPerPage = 15
	
	private var commonHeaders: [String : String] {
		return [
			"Accept-Version" : "v1",
			"Authorization" : "Client-ID \(apiKey)"
		]
	}
	
	private func performRequest(stringUrl: String, completion: @escaping (Data?, TopPhotosError?) -> Void) {
		guard Reachability.isConnectedToNetwork() else {
			completion(nil, TopPhotosError.NoInternetConnection)
			return
		}
		
		guard let url = URL(string: apiPath + stringUrl) else {
			completion(nil, TopPhotosError.ConnecitonIssue)
			return
		}
		
		var request = URLRequest(url: url)
		for (key, value) in commonHeaders {
			request.addValue(value, forHTTPHeaderField: key)
		}
		
		let task = session.dataTask(with: request) { data, response, error in
			guard let data = data,
				  let response = response as? HTTPURLResponse,
				  response.statusCode == 200,
				  error == nil
			else {
				completion(nil, TopPhotosError.ConnecitonIssue)
				return
			}
			
			completion(data, nil)
		}
		task.resume()
		
	}
	
	public func getPhotos(topicID: String? = nil, page: Int = 1, completion: @escaping ([PhotoModel]?, TopPhotosError?) -> Void) {
		var urlString = "photos?page=\(page)&per_page=\(photosPerPage)&order_by=latest"
		if let topicID {
			urlString = "topics/\(topicID)/" + urlString
		}
		performRequest(stringUrl: urlString) { data, error in
			if let error {
				completion(nil, error)
			} else if let data {
				if let parsedPhotos = self.parsePhotos(from: data) {
					completion(parsedPhotos, nil)
				} else {
					completion(nil, .NoContent)
				}
			} else {
				completion(nil, .ConnecitonIssue)
			}
		}
	}
	
	public func getPhotoDetails(id: String, completion: @escaping (PhotoDetailsModel?, TopPhotosError?) -> Void) {
		let urlString = "photos/\(id)"
		performRequest(stringUrl: urlString) { data, error in
			if let error {
				completion(nil, error)
			} else if let data {
				if let parsedPhotoDetails = self.parsePhotoDetails(from: data) {
					completion(parsedPhotoDetails, nil)
				} else {
					completion(nil, .NoContent)
				}
			} else {
				completion(nil, .ConnecitonIssue)
			}
		}
	}
	
	public func getTopics(completion: @escaping ([TopicModel]?, TopPhotosError?) -> Void) {		
		let urlString = "topics?page=1&per_page=\(topicsPerPage)&order_by=featured"
		performRequest(stringUrl: urlString) { data, error in
			if let error {
				completion(nil, error)
			} else if let data {
				if let parsedTopics = self.parseTopics(from: data) {
					completion(parsedTopics, nil)
				} else {
					completion(nil, .NoContent)
				}
			} else {
				completion(nil, .ConnecitonIssue)
			}
		}
	}
	
	public func parsePhotos(from data: Data?) -> [PhotoModel]? {
		guard let jsonData = data else { return nil }
		let decoder = JSONDecoder()
		let photosList = try? decoder.decode([PhotoModel].self, from: jsonData)

		return photosList
	}
	
	public func parsePhotoDetails(from data: Data?) -> PhotoDetailsModel? {
		guard let jsonData = data else { return nil }
		let decoder = JSONDecoder()
		let photosList = try? decoder.decode(PhotoDetailsModel.self, from: jsonData)

		return photosList
	}
	
	func parseTopics(from data: Data?) -> [TopicModel]? {
		guard let jsonData = data else { return nil }
		let decoder = JSONDecoder()
		let photosList = try? decoder.decode([TopicModel].self, from: jsonData)

		return photosList
	}
	
}
