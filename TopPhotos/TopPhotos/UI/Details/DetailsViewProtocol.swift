//
//  DetailsViewProtocol.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import Foundation
import UIKit

protocol DetailsViewProtocol: BaseViewProtocol {
	
	func showDetails(description: String, author: String)
	func showBigPicture(image: UIImage)
	func closeView()
	
}
