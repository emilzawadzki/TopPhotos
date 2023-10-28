//
//  ListVC.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import UIKit

private let cellReuseIdentifier = "photoMiniCell"

class ListVC: BaseVC<ListPresenter>, ListViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource {

	@IBOutlet weak var titleLabel: UILabel?
	@IBOutlet weak var selectCategoryLabel: UILabel?
	@IBOutlet weak var photosLabel: UILabel?
	@IBOutlet weak var noResultsLabel: UILabel?
	@IBOutlet weak var collectionView: UICollectionView?
	@IBOutlet weak var filterStackView: UIStackView?
	@IBOutlet weak var topGradientView: GradientView?
	@IBOutlet weak var bottomGradientView: GradientView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		titleLabel?.text = "Title".localized()
		selectCategoryLabel?.text = "SelectCategory".localized()
		photosLabel?.text = "Photos".localized()
		noResultsLabel?.text = "NoResults".localized()
		
		filterStackView?.arrangedSubviews.forEach { view in
			view.removeFromSuperview()
		}
	}
	
	func reloadList() {
		UIView.animate(withDuration: 1.0, animations: {
			self.collectionView?.alpha = 1
		})
		collectionView?.reloadData()
	}
	
	func scrollToTop() {
		collectionView?.setContentOffset(CGPoint(x:0, y:0), animated: true)
	}
	
	func showEmptyScreen() {
		UIView.animate(withDuration: 1.0, animations: {
			self.collectionView?.alpha = 0
			self.noResultsLabel?.alpha = 1
		})
	}
	
	func showFilters(_ filters: [String]) {
		guard let filterStackView else {
			return
		}
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
		guard let filterStackView else {
			return
		}
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
		let photoID = presenter?.getPhotoID(index: indexPath.row)
		cell.photoID = photoID
		cell.photoImage.image = nil
		presenter?.getImage(index: indexPath.row) { [weak cell] image in
			// check ID in case if cell was already reused
			if cell?.photoID == photoID {
				cell?.photoImage.image = image
			}
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presenter?.didSelectPhoto(index: indexPath.row)
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		presenter?.willDisplayCell(index: indexPath.row)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		// workaround for cgColors used in gradient - dynamic color doesn't work, I need to setup it again after changing trait collection
		topGradientView?.setupGradient()
		bottomGradientView?.setupGradient()
	}
	
}

