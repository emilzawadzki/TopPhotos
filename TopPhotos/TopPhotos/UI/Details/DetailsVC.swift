//
//  DetailsVC.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import Foundation
import UIKit

class DetailsVC: BaseVC<DetailsPresenter>, DetailsViewProtocol {
	
	@IBOutlet var bigImage: UIImageView!
	
	@IBOutlet var descriptionLabel: UILabel!
	@IBOutlet var authorLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		descriptionLabel.text = nil
		authorLabel.text = nil
	}
	
	func showDetails(description: String, author: String) {
		//TODO: animation
		descriptionLabel.text = description
		authorLabel.text = author
	}
	
	func showBigPicture(image: UIImage) {
		//TODO: animation
		bigImage.image = image
	}
	
	@IBAction func closeButtonTapped(_ sender: Any) {
		presenter?.closeButtonTapped()
	}
	
	func closeView() {
		dismiss(animated: true)
	}
	
	@IBAction func saveToPhotosButtonTapped(_ sender: Any) {
		presenter?.saveToPhotosButtonTapped()
	}
	
}
