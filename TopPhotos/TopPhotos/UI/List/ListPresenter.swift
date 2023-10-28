//
//  ListPresenter.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import Foundation
import UIKit

fileprivate let allFiltersIndex = 0
fileprivate let firstPageIndex = 1

class ListPresenter: BasePresenter, FilterViewDelegate {
	
	private weak var view : ListViewProtocol?
	
	private var photos: [PhotoModel]?
	private(set) var topics: [TopicModel]?
	private(set) var selectedTopic: TopicModel?
	private(set) var photosPage = firstPageIndex
	
	private var viewDidAlreadyAppeared = false
	
	var numberOfPhotos: Int {
		return photos?.count ?? 0
	}
	
	init(view: ListViewProtocol) {
		self.view = view
		super.init()
	}
	
	override func onViewDidAppear() {
		super.onViewDidAppear()
		
		guard !viewDidAlreadyAppeared else {
			return
		}
		viewDidAlreadyAppeared.toggle()
		
		view?.showLoadingPopup()
		
		let group = DispatchGroup()
		group.enter()
		var photosError: Error?
		apiConnector.getPhotos(topicID: nil, page: photosPage, completion: { [weak self] photos, error in
			if let error {
				photosError = error
			} else {
				self?.photos = photos
			}
			group.leave()
		})
		group.enter()
		apiConnector.getTopics(completion: { [weak self] topics, error in
			if var topics {
				// custom topic for all pictures
				let topicAll = TopicModel(id: topicAllPicturesID, title: "All")
				topics.insert(topicAll, at: allFiltersIndex)
				self?.topics = topics
			}
			group.leave()
		})
		
		group.notify(queue: .main) {
			self.view?.hideLoadingPopup()
			if let photosError {
				//TODO: add string to the error
				self.view?.showSimpleError("Error", cancellable: false)
			} else if let photos = self.photos, photos.count > 0 {
				self.view?.reloadList()
			} else {
				self.view?.showEmptyScreen()
			}
			if let topics = self.topics {
				self.view?.showFilters(topics.map { $0.title })
				self.view?.showFilterAsSelected(filterIndex: allFiltersIndex)
			}
		}
	}
	
	func getImageForPhotoCell(cell: MiniPhotoCell, index: Int) {
		guard let photos, photos.count > index else {
			return
		}
		let photoModel = photos[index]
		cell.photoID = photoModel.id
		cell.photoImage.image = nil
		guard let imagePath = photoModel.smallImagePath, let url = URL(string: imagePath) else {
			return
		}
		//TODO: add delegate for cell
		DispatchQueue.global().async {
			// check ID in case if cell was reused for other image
			if let data = try? Data(contentsOf: url), cell.photoID == photoModel.id {
				DispatchQueue.main.async {
					cell.photoImage.image = UIImage(data: data)
				}
			}
		}
	}
	
	func didSelectPhoto(index: Int) {
		guard let photos, photos.count > index else {
			return
		}
		let photoModel = photos[index]
		
		if let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailsVC") as? DetailsVC {
			detailsVC.presenter = DetailsPresenter(view: detailsVC, photoModel: photoModel)
			detailsVC.modalPresentationStyle = .fullScreen
			//TODO: add coordinator
			if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let root = appDelegate.window?.rootViewController {
				root.present(detailsVC, animated: true)
			}
		}
	}
	
	func filterSelected(filterIndex: Int) {
		guard let topics, topics.count > filterIndex else {
			return
		}
		let newTopic = topics[filterIndex]
		
		if newTopic.id == topicAllPicturesID {
			guard selectedTopic != nil else {
				return
			}
			selectedTopic = nil
		} else {
			guard newTopic.id != selectedTopic?.id else {
				return
			}
			selectedTopic = newTopic
		}
		view?.showFilterAsSelected(filterIndex: filterIndex)
		photosPage = firstPageIndex
		photos = []
		view?.scrollToTop()
		getMorePhotos()
		
	}
	
	func willDisplayCell(index: Int) {
		// load more photos when showing last cell
		guard let photos, photos.count - 1 == index else {
			return
		}
		photosPage += 1
		getMorePhotos()
	}
	
	func getMorePhotos() {
		view?.showLoadingPopup()
		apiConnector.getPhotos(topicID: selectedTopic?.id, page: photosPage, completion: { [weak self] photos, error in
			if let error {
				//TODO:
			} else if let photos {
				DispatchQueue.main.async {
					self?.view?.hideLoadingPopup()
					self?.photos?.append(contentsOf: photos)
					self?.view?.reloadList()
				}
			}
		})
	}
	
}
