//
//  DetailsPresenter.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import Foundation
import UIKit

class DetailsPresenter: BasePresenter {
	
	private weak var view : DetailsViewProtocol?
	private var photoModel: PhotoModel
	private var loadedImage: UIImage?
	private var imageSaver: ImageSaver?
	
	init(view: DetailsViewProtocol, photoModel: PhotoModel) {
		self.view = view
		self.photoModel = photoModel
		super.init()
	}
	
	override func onViewDidAppear() {
		super.onViewDidAppear()
		view?.showLoadingPopup()
		apiConnector.getPhotoDetails(id:photoModel.id, completion: { [weak self] photoDetails, error in
			DispatchQueue.main.async {
				self?.view?.hideLoadingPopup()
				if let error {
					self?.view?.showSimpleError("Error")
				} else if let photoDetails {
					self?.view?.showDetails(description: photoDetails.description ?? "missing description", author: photoDetails.user.name)
					guard let imagePath = photoDetails.bigImagePath, let url = URL(string: imagePath) else {
						return
					}
					DispatchQueue.global().async {
						if let data = try? Data(contentsOf: url) {
							DispatchQueue.main.async {
								if let image = UIImage(data: data) {
									self?.loadedImage = image
									self?.view?.showBigPicture(image: image)
								}
							}
						}
					}
				} else {
					self?.view?.showSimpleError("Error")
				}
			}
		})
		
		imageSaver = ImageSaver(completionBlock: { [weak self] success in
			if success {
				self?.view?.showInfoPopup("Saving successfull")
			} else {
				self?.view?.showSimpleError("Saving failed")
			}
		})
	}
	
	func closeButtonTapped() {
		view?.closeView()
	}
	
	func saveToPhotosButtonTapped() {
		guard let loadedImage else {
			return
		}
		imageSaver?.saveInPhotosAlbum(image: loadedImage)
	}
	
}
