//
//  BaseVC.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import UIKit

class BaseVC<T: BasePresenter>: UIViewController, BaseViewProtocol {
	
	var presenter: T?
	
	private var loadingSpinner: UIActivityIndicatorView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		presenter?.onViewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presenter?.onViewWillAppear()
		loadingSpinner?.startAnimating()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		presenter?.onViewDidAppear()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		presenter?.onViewWillDisappear()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		presenter?.onViewDidDisappear()
		loadingSpinner?.stopAnimating()
	}
	
	
	func showLoadingPopup() {
		DispatchQueue.main.async {
			guard self.loadingSpinner == nil else {
				// spinner is already displayed
				return
			}
			let loadingSpinner = UIActivityIndicatorView(style: .large)
			loadingSpinner.backgroundColor = UIColor(named: "TextCommon")?.withAlphaComponent(0.5)
			self.view.addSubview(loadingSpinner)
			loadingSpinner.frame = self.view.bounds
			loadingSpinner.startAnimating()
			self.loadingSpinner = loadingSpinner
		}
	}
	
	func hideLoadingPopup() {
		// min spinner duration set to avoid blinking with spinner view
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.loadingSpinner?.stopAnimating()
			self.loadingSpinner?.removeFromSuperview()
			self.loadingSpinner = nil
		}
	}
	
	func showSimpleError(_ errorText: String) {
		let alert = UIAlertController(title: nil, message: errorText, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Error", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
}
