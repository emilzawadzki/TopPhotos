//
//  PhotoDetailsModel.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import Foundation

public struct PhotoDetailsModel: Codable, Identifiable {
	
	public var id: String
	public var description: String?
	public var alt_description: String?
	public var urls: [String : String]
	
	public var user: UserModel
	
	public var bigImagePath: String? {
		return urls["regular"]
	}
	
	public var photoDescription: String? {
		return description ?? alt_description
	}
	
}
