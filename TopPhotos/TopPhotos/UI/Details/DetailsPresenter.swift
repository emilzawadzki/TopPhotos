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
	private var photoID: String
	private var loadedImage: UIImage?
	private var imageSaver: ImageSaver?
	
	init(view: DetailsViewProtocol, photoID: String) {
		self.view = view
		self.photoID = photoID
		super.init()
	}
	
	override func onViewDidLoad() {
		super.onViewDidLoad()
		imageSaver = ImageSaver(completionBlock: { [weak self] success in
			if success {
				self?.view?.showInfoPopup("ImageSaveSuccess".localized())
			} else {
				self?.view?.showSimpleError("ImageSaveFailure".localized(), cancellable: true)
			}
		})
	}
	
	override func onViewDidAppear() {
		super.onViewDidAppear()
		loadDetails()
	}
	
	private func loadDetails() {
		view?.showLoadingPopup()
		apiConnector.getPhotoDetails(id:photoID, completion: { [weak self] photoDetails, error in
			DispatchQueue.main.async {
				self?.view?.hideLoadingPopup()
				if let error {
					self?.view?.showSimpleError(error.customMessage, cancellable: true)
				} else if let photoDetails {
					self?.view?.showDetails(description: photoDetails.description ?? "MissingDescription".localized(), author: photoDetails.user.name)
					self?.loadImage(imagePath: photoDetails.bigImagePath)
				} else {
					self?.view?.showSimpleError(TopPhotosError.NoContent.customMessage, cancellable: true)
				}
			}
		})
	}
	
	private func loadImage(imagePath : String?) {
		guard let imagePath, let url = URL(string: imagePath) else {
			return
		}
		DispatchQueue.global().async {
			if let data = try? Data(contentsOf: url) {
				DispatchQueue.main.async { [weak self] in
					if let image = UIImage(data: data) {
						self?.loadedImage = image
						self?.view?.showBigPicture(image: image)
					}
				}
			}
		}
	}
	
	override func onRetryTapped() {
		super.onRetryTapped()
		loadDetails()
	}
	
	override func onCancelTapped() {
		super.onCancelTapped()
		closeButtonTapped()
	}
	
	func closeButtonTapped() {
		view?.closeView()
	}
	
	func saveToPhotosButtonTapped() {
		guard let loadedImage else {
			view?.showSimpleError("ImageSaveFailure".localized(), cancellable: true)
			return
		}
		imageSaver?.saveInPhotosAlbum(image: loadedImage)
	}
	
}
