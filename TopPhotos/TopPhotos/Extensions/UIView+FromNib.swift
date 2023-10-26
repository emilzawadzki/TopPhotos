//
//  UIView+FromNib.swift
//  TopPhotos
//
//  Created by Emil Zawadzki on 26/10/2023.
//

import Foundation
import UIKit

public extension UIView {
	class func fromNib(nibNameOrNil: String? = nil) -> Self {
		return fromNib(nibNameOrNil: nibNameOrNil, type: self)
	}
	
	class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
		let v: T? = fromNib(nibNameOrNil: nibNameOrNil, type: T.self)
		return v!
	}
	
	class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
		var view: T?
		let name: String
		if let nibName = nibNameOrNil {
			name = nibName
		} else {
			name = nibName
		}
		let bundle = Bundle(for: type)
		let nibViews = bundle.loadNibNamed(name, owner: nil, options: nil)
		for v in nibViews! {
			if let tog = v as? T {
				view = tog
			}
		}
		return view
	}
	
	class var nibName: String {
		let name = "\(self)".components(separatedBy: ".").first ?? ""
		return name
	}
	class var nib: UINib? {
		let bundle = Bundle(for: self)
		if let _ = bundle.path(forResource: nibName, ofType: "nib") {
			return UINib(nibName: nibName, bundle: bundle)
		} else {
			return nil
		}
	}
}
