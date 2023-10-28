//
//  GradientView.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 28/10/2023.
//

import Foundation
import UIKit

@IBDesignable final class GradientView: UIView {

	@IBInspectable var startColor: UIColor = UIColor.clear
	@IBInspectable var endColor: UIColor = UIColor.clear
	/// if between 0 and 100 (not included), color between start and end will be at this point
	@IBInspectable var midColorPointPercentage: CGFloat = 50

	override class var layerClass: AnyClass {
		get {
			return CAGradientLayer.self
		}
	}
	
	#if TARGET_INTERFACE_BUILDER
	override func draw(_ rect: CGRect) {
		let gradient: CAGradientLayer = CAGradientLayer()
		gradient.frame = CGRect(x: CGFloat(0),
								y: CGFloat(0),
								width: self.frame.size.width,
								height: self.frame.size.height)
		gradient.colors = [startColor.cgColor, endColor.cgColor]
		gradient.zPosition = -1
		layer.addSublayer(gradient)
	}
	#endif

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupGradient()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		DispatchQueue.main.async {
			self.setupGradient()
		}
	}
	
	func setGradientPoints(startPoint: CGPoint, endPoint: CGPoint) {
		let gradient = self.layer as! CAGradientLayer
		gradient.startPoint = startPoint
		gradient.endPoint = endPoint
	}

	func setupGradient() {
		let gradient = self.layer as! CAGradientLayer
		
		let currentInterfaceStyle: UIUserInterfaceStyle
		if
			let appDelegate = UIApplication.shared.delegate as? AppDelegate,
			let window = appDelegate.window,
			window.overrideUserInterfaceStyle != .unspecified
		{
			currentInterfaceStyle = window.overrideUserInterfaceStyle
		} else {
			currentInterfaceStyle = self.traitCollection.userInterfaceStyle
		}
		
		var startColor = startColor.resolvedColor(with: .init(userInterfaceStyle: currentInterfaceStyle))
		var endColor = endColor.resolvedColor(with: .init(userInterfaceStyle: currentInterfaceStyle))
		
		// Since clear color is actually black with alpha 0, going from white to clear means in middle there will be white:0.5, alpha:0.5. Here is a workaround for that
		if startColor.isEqual(UIColor.clear) {
			startColor = endColor.withAlphaComponent(0)
		}
		if endColor.isEqual(UIColor.clear) {
			endColor = startColor.withAlphaComponent(0)
		}
		
		if midColorPointPercentage > 0 && midColorPointPercentage < 100 {
			var (startRed, startGreen, startBlue, startAlpha) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
			var (endRed, endGreen, endBlue, endAlpha) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))

			startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
			endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
			
			let midColor = UIColor(red: (startRed + endRed) / 2.0, green: (startGreen + endGreen) / 2.0, blue: (startBlue + endBlue) / 2.0, alpha: (startAlpha + endAlpha) / 2.0)
			gradient.colors = [startColor.cgColor, midColor.cgColor, endColor.cgColor]
			gradient.locations = [0, NSNumber(value: midColorPointPercentage / 100.0), 1]
		}
		else {
			gradient.colors = [startColor.cgColor, endColor.cgColor]
		}
	}

}
