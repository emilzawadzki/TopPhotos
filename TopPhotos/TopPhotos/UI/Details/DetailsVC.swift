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
	
	@IBOutlet var detailsStackView: UIStackView!
	@IBOutlet var descriptionLabel: UILabel!
	@IBOutlet var authorTitleLabel: UILabel!
	@IBOutlet var authorLabel: UILabel!
	@IBOutlet var closeButton: UIButton!
	@IBOutlet var saveButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		descriptionLabel.text = nil
		authorLabel.text = nil
		authorTitleLabel.text = "Author".localized()
		closeButton.setTitle("ButtonClose".localized(), for: .normal)
		saveButton.setTitle("ButtonSave".localized(), for: .normal)
		detailsStackView.alpha = 0
	}
	
	func showDetails(description: String, author: String) {
		descriptionLabel.text = description
		authorLabel.text = author
		UIView.animate(withDuration: 1.0, animations: {
			self.detailsStackView.alpha = 1
		})
	}
	
	func showBigPicture(image: UIImage) {
		UIView.transition(with: bigImage, duration: 1.0, options: [ .allowUserInteraction, .beginFromCurrentState, .transitionCrossDissolve ]) {
			self.bigImage.image = image
		}
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
