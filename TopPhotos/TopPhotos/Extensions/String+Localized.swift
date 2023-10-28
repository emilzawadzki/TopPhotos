//
//  String+Localized.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 28/10/2023.
//

import Foundation

extension String {
	func localized() -> String {
		return NSLocalizedString(self, comment: "")
	}
}
