//
//  ListVC.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import UIKit

private let cellReuseIdentifier = "photoMiniCell"

class ListVC: BaseVC<ListPresenter>, ListViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource {

	@IBOutlet var collectionView: UICollectionView!
	@IBOutlet var filterStackView: UIStackView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		filterStackView.arrangedSubviews.forEach { view in
			view.removeFromSuperview()
		}
	}
	
	func reloadList() {
		//TODO: add animation
		collectionView.isHidden = false
		collectionView.reloadData()
	}
	
	func scrollToTop() {
		collectionView.setContentOffset(CGPoint(x:0, y:0), animated: true)
	}
	
	func showEmptyScreen() {
		//TODO: add animation
		collectionView.isHidden = true
	}
	
	func showFilters(_ filters: [String]) {
		filterStackView.arrangedSubviews.forEach { view in
			view.removeFromSuperview()
		}
		var index = 0
		filters.forEach { filterName in
			let filterView = FilterControlView.fromNib()
			filterView.delegate = presenter
			filterView.categoryIndex = index
			filterView.filterNameLabel.text = filterName
			filterStackView.addArrangedSubview(filterView)
			index += 1
		}
	}
	
	func showFilterAsSelected(filterIndex: Int) {
		var index = 0
		for case let filterView as FilterControlView in filterStackView.arrangedSubviews {
			filterView.showAsSelected(index == filterIndex)
			index += 1
		}
	}


	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return presenter?.numberOfPhotos ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? MiniPhotoCell else {
			return UICollectionViewCell()
		}
		presenter?.getImageForPhotoCell(cell: cell, index: indexPath.row)
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presenter?.didSelectPhoto(index: indexPath.row)
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		presenter?.willDisplayCell(index: indexPath.row)
	}
	
}

