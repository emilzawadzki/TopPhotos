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
	private weak var coordinator : Coordinator?
	
	private var photos: [PhotoModel]?
	private(set) var topics: [TopicModel]?
	private(set) var selectedTopic: TopicModel?
	private(set) var photosPage = firstPageIndex
	
	private var viewDidAlreadyAppeared = false
	
	var numberOfPhotos: Int {
		return photos?.count ?? 0
	}
	
	init(view: ListViewProtocol, coordinator : Coordinator) {
		self.view = view
		self.coordinator = coordinator
		super.init()
	}
	
	override func onViewDidAppear() {
		super.onViewDidAppear()
		
		// do below code only once
		guard !viewDidAlreadyAppeared else {
			return
		}
		viewDidAlreadyAppeared.toggle()
		
		view?.showLoadingPopup()
		// get topics & photos
		let group = DispatchGroup()
		group.enter()
		var photosError: TopPhotosError?
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
				// add custom topic for all pictures
				let topicAll = TopicModel(id: topicAllPicturesID, title: "AllPicturesFilter".localized())
				topics.insert(topicAll, at: allFiltersIndex)
				self?.topics = topics
				self?.selectedTopic = topicAll
			}
			group.leave()
		})
		
		group.notify(queue: .main) {
			self.view?.hideLoadingPopup()
			if let photosError {
				self.view?.showSimpleError(photosError.customMessage, cancellable: false)
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
	
	override func onRetryTapped() {
		loadMorePhotos()
	}
	
	func getPhotoID(index: Int) -> String? {
		guard let photos, photos.count > index else {
			return nil
		}
		let photoModel = photos[index]
		return photoModel.id
	}
	
	func getImage(index: Int, completionBlock: @escaping (UIImage?) -> Void) {
		guard let photos, photos.count > index else {
			return
		}
		let photoModel = photos[index]
		guard let imagePath = photoModel.smallImagePath, let url = URL(string: imagePath) else {
			return
		}
		// get image in async queue
		DispatchQueue.global(qos: .background).async {
			if let data = try? Data(contentsOf: url) {
				DispatchQueue.main.async {
					completionBlock(UIImage(data: data))
				}
			}
		}
	}
	
	func didSelectPhoto(index: Int) {
		guard let photos, photos.count > index else {
			return
		}
		let photoModel = photos[index]
		
		coordinator?.presentDetailsView(photoID: photoModel.id)
	}
	
	func filterSelected(filterIndex: Int) {
		guard let topics, topics.count > filterIndex else {
			return
		}
		let newTopic = topics[filterIndex]
		
		guard newTopic.id != selectedTopic?.id else {
			//don't reload list for the same topic
			return
		}
		selectedTopic = newTopic
		view?.showFilterAsSelected(filterIndex: filterIndex)
		photosPage = firstPageIndex
		photos = [] // remove photos from previous topic
		view?.scrollToTop()
		loadMorePhotos()
		
	}
	
	func willDisplayCell(index: Int) {
		// load more photos when showing last cell
		guard let photos, photos.count - 1 == index else {
			return
		}
		photosPage += 1 // load photos from the next page
		loadMorePhotos()
	}
	
	func loadMorePhotos() {
		view?.showLoadingPopup()
		// the app should use nil as topic ID, when all pictures filter is selected
		let topicID: String? = selectedTopic?.id != topicAllPicturesID ? selectedTopic?.id : nil
		apiConnector.getPhotos(topicID: topicID, page: photosPage, completion: { [weak self] photos, error in
			guard let self else {
				return
			}
			DispatchQueue.main.async {
				self.view?.hideLoadingPopup()
				if let error {
					self.view?.showSimpleError(error.customMessage, cancellable: false)
				} else if let photos, photos.count > 0 {
					self.photos?.append(contentsOf: photos)
					self.view?.reloadList()
				} else {
					self.view?.showEmptyScreen()
				}
			}
		})
	}
	
}
