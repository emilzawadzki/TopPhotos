//
//  AppDelegate.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 25/10/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
		if let listVC = mainVC as? ListVC {
			listVC.presenter = ListPresenter(view: listVC)
		}
		window?.rootViewController = mainVC
		
		return true
	}


}

