//
//  BasePresenter.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import Foundation

class BasePresenter: NSObject {
	
	/// default value but can be replaced for tests
	internal var apiConnector: ApiConnectorProtocol = ApiConnector()
	
	func onViewDidLoad() {
		// override if needed in child classes
	}
	
	func onViewWillAppear() {
		// override if needed in child classes
	}
	
	func onViewDidAppear() {
		// override if needed in child classes
	}
	
	func onViewWillDisappear() {
		// override if needed in child classes
	}
	
	func onViewDidDisappear() {
		// override if needed in child classes
	}
	
	func onRetryTapped() {
		// override if needed in child classes
	}
	
	func onCancelTapped() {
		// override if needed in child classes
	}
	
}
