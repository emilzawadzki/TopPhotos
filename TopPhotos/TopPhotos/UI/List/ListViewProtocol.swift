//
//  ListViewProtocol.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import Foundation

protocol ListViewProtocol: BaseViewProtocol {
	
	func reloadList()
	
	func scrollToTop()
	
	func showEmptyScreen()
	
	func showFilters(_ filters: [String])
	
	func showFilterAsSelected(filterIndex: Int)
}
