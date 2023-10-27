//
//  ApiConnector.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import Foundation

enum ApiErrors: Error {
	case ConnecitonIssue
	case NoPhotos
}

class ApiConnector: ApiConnectorProtocol {
	
	private var session = URLSession.shared
	
	private let apiKey = "4KQGrzmAvcI8GrnEDmFN29d67zIcT3cW0H2gSjyrXek"
	private let apiPath = "https://api.unsplash.com/"
	private let photosPerPage = 100
	private let topicsPerPage = 30
	
	public func getPhotos(topicID: String? = nil, page: Int = 1, completion: @escaping ([PhotoModel]?, Error?) -> Void) {
		var urlString = apiPath + ((topicID != nil) ? "topics/\(topicID!)/" : "") + "photos?page=\(page)&per_page=\(photosPerPage)&order_by=latest"
		guard let url = URL(string: urlString) else {
			completion(nil, ApiErrors.ConnecitonIssue)
			return
		}
		var request = URLRequest(url: url)
		request.addValue("v1", forHTTPHeaderField: "Accept-Version")
		request.addValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
		let task = session.dataTask(with: request) { data, response, error in
			guard let data = data,
				  let response = response as? HTTPURLResponse,
				  response.statusCode == 200,
				  error == nil
			else {
				completion(nil, ApiErrors.ConnecitonIssue)
				return
			}
			if let parsedPhotos = self.parsePhotos(from: data) {
				completion(parsedPhotos, nil)
			} else {
				completion(nil, ApiErrors.NoPhotos)
				return
			}
		}
		task.resume()
		
	}
	
	public func getPhotoDetails(id: String, completion: @escaping (PhotoDetailsModel?, Error?) -> Void) {
		guard let url = URL(string: "\(apiPath)photos/\(id)") else {
			completion(nil, ApiErrors.ConnecitonIssue)
			return
		}
		var request = URLRequest(url: url)
		request.addValue("v1", forHTTPHeaderField: "Accept-Version")
		request.addValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
		let task = session.dataTask(with: request) { data, response, error in
			guard let data = data,
				  let response = response as? HTTPURLResponse,
				  response.statusCode == 200,
				  error == nil
			else {
				completion(nil, ApiErrors.ConnecitonIssue)
				return
			}
			if let parsedPhotoDetails = self.parsePhotoDetails(from: data) {
				completion(parsedPhotoDetails, nil)
			} else {
				completion(nil, ApiErrors.NoPhotos)
				return
			}
		}
		task.resume()
		
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
	
	public func getTopics(completion: @escaping ([TopicModel]?, Error?) -> Void) {
		guard let url = URL(string: "\(apiPath)topics?page=1&per_page=\(topicsPerPage)&order_by=featured") else {
			completion(nil, ApiErrors.ConnecitonIssue)
			return
		}
		var request = URLRequest(url: url)
		request.addValue("v1", forHTTPHeaderField: "Accept-Version")
		request.addValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
		let task = session.dataTask(with: request) { data, response, error in
			guard let data = data,
				  let response = response as? HTTPURLResponse,
				  response.statusCode == 200,
				  error == nil
			else {
				completion(nil, ApiErrors.ConnecitonIssue)
				return
			}
			if let parsedTopics = self.parseTopics(from: data) {
				completion(parsedTopics, nil)
			} else {
				completion(nil, ApiErrors.NoPhotos)
				return
			}
		}
		task.resume()
		
	}
	
	func parseTopics(from data: Data?) -> [TopicModel]? {
		guard let jsonData = data else { return nil }
		let decoder = JSONDecoder()
		let photosList = try? decoder.decode([TopicModel].self, from: jsonData)

		return photosList
	}
	
}
