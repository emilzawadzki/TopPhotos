//
//  UserModel.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import Foundation

public struct UserModel: Codable, Identifiable {
	public var id: String
	public var name: String
}
