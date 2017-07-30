//
//  XibLoadable.swift
//  Additions
//
//  Created by James Froggatt on 08.03.2017.
//
//

#if os(iOS) || os(tvOS)
	import UIKit
	
	public protocol XibLoadable: AnyObject {}

	public extension XibLoadable where Self: UIView {
		@available(iOSApplicationExtension 9, *)
		func setupFromXib(named name: String? = nil) {
			self.autolayout()
			
			let bundle = Bundle(for: type(of: self))
			let nibName = name ?? String(describing: type(of: self))
			let nib = UINib(nibName: nibName, bundle: bundle)
			
			let view = (nib.instantiate(withOwner: self, options: nil).first as! UIView).autolayout()
			view.frame = self.bounds
			self.addSubview(view)
			self.constrain(subview: view, .allSides)
		}
	}
#endif
