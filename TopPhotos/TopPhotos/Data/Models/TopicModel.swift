//
//  TopicModel.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 26/10/2023.
//

import Foundation

/// used for custom, generated in code topic for all images
let topicAllPicturesID = "-1"

public struct TopicModel: Codable, Identifiable {
	public var id: String
	public var title: String
}
