//
//  TopPhotosErrors.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 28/10/2023.
//

import Foundation

enum TopPhotosError: Error {
	case NoInternetConnection
	case ConnecitonIssue
	case NoContent
	
	var customMessage: String {
		switch self {
		case .NoInternetConnection:
			return "ErrorNoInternetConnection".localized()
		case .ConnecitonIssue:
			return "ErrorConnecitonIssue".localized()
		case .NoContent:
			return "ErrorNoContent".localized()
		}
	}
	
}
