//
//  Coordinator.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 28/10/2023.
//

import Foundation
import UIKit

class Coordinator {
	
	private var navigationController: UINavigationController?
	
	private var mainStoryboard: UIStoryboard {
		return UIStoryboard(name: "Main", bundle: nil)
	}
	
	func startMainFlow(inWindow window: UIWindow?) {
		guard let listVC = mainStoryboard.instantiateInitialViewController() as? ListVC else {
			return
		}
		listVC.presenter = ListPresenter(view: listVC, coordinator: self)
		
		let navigationController = UINavigationController(rootViewController: listVC)
		navigationController.setNavigationBarHidden(true, animated: false)
		self.navigationController = navigationController
		
		window?.rootViewController = navigationController
	}
	
	func presentDetailsView(photoID: String) {
		guard let detailsVC = mainStoryboard.instantiateViewController(withIdentifier: "detailsVC") as? DetailsVC else {
			return
		}
		detailsVC.presenter = DetailsPresenter(view: detailsVC, photoID: photoID)
		detailsVC.modalPresentationStyle = .fullScreen
		navigationController?.present(detailsVC, animated: true)
	}
	
}
