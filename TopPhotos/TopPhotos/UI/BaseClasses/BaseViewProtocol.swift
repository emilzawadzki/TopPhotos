//
//  BaseViewProtocol.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import Foundation

protocol BaseViewProtocol: AnyObject {
	func showLoadingPopup()
	func hideLoadingPopup()
	func showSimpleError(_ errorText: String)
	func showInfoPopup(_ info: String)
}
