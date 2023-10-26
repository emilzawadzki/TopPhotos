//
//  PhotoModel.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import Foundation

public struct PhotoModel: Codable, Identifiable {
	public var id: String
	public var urls: [String : String]
	
	public var smallImagePath: String? {
		return urls["small"]
	}
}
