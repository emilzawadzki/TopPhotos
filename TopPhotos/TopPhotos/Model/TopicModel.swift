//
//  TopicModel.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 26/10/2023.
//

import Foundation

let topicAllPicturesID = "-1"

public struct TopicModel: Codable, Identifiable {
	public var id: String
	public var title: String
}
