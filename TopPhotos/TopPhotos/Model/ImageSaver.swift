//
//  ImageSaver.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 26/10/2023.
//

import UIKit

class ImageSaver: NSObject {
	
	private var completionBlock: (Bool) -> Void
	
	init(completionBlock: @escaping (Bool) -> Void) {
		self.completionBlock = completionBlock
	}
	
	func saveInPhotosAlbum(image: UIImage) {
		UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
	}

	@objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		completionBlock(error == nil)
	}
}
