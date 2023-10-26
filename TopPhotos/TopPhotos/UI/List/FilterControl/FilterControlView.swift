//
//  FilterControlView.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 26/10/2023.
//

import UIKit

protocol FilterViewDelegate {
	func filterSelected(filterIndex: Int)
}

class FilterControlView: UIView {
	
	@IBOutlet var filterNameLabel: UILabel!
	@IBOutlet var backgroundView: UIView!

	var delegate: FilterViewDelegate?
	var categoryIndex: Int = 0
	
	private var selectedTextColor = UIColor(named: "BackgroundCommon")
	private var unselectedTextColor = UIColor(named: "TextCommon")
	private var selectedBackgroundColor = UIColor(named: "TextCommon")
	private var unselectedBackgroundColor = UIColor(named: "ButtonBackground")
	

	@IBAction func filterButtonTouchDown(_ sender: UIButton) {
		backgroundView.alpha = 0.6
	}
	
	@IBAction func filterButtonTouchUp(_ sender: UIButton) {
		backgroundView.alpha = 1
	}

	@IBAction func categoryTap(_ sender: Any) {
		delegate?.filterSelected(filterIndex: categoryIndex)
	}
	
	func showAsSelected(_ selected: Bool, animated: Bool = true) {
		UIView.transition(with: filterNameLabel, duration: animated ? 0.5 : 0) {
			self.filterNameLabel.textColor = selected ? self.selectedTextColor : self.unselectedTextColor
		}
		UIView.transition(with: backgroundView, duration: animated ? 0.3 : 0) {
			self.backgroundView.backgroundColor = selected ? self.selectedBackgroundColor : self.unselectedBackgroundColor
		}
	}
	
}
