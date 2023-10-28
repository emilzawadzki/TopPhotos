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
	private var coordinator: Coordinator?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		coordinator = Coordinator()
		coordinator?.startMainFlow(inWindow: window)
		
		return true
	}


}

