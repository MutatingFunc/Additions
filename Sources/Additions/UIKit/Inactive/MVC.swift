//
//  MVC.swift
//  Additions
//
//  Created by James Froggatt on 02.08.2018.
//

import UIKit

//inactive - coordinator pattern works better

//Views either handle view display, or view layout / touch, not both.
//ViewControllers should either handle view display / layout, or logic.
//ViewControllers with logic (Coordinators) should only contain logic, and use child view controllers for presentation.

#if canImport(UIKit)
///Displays a single content ViewController.
@available(iOSApplicationExtension 9, iOS 9, *)
open class ContainerViewController: UIViewController {
	override open func viewDidLoad() {
		view.backgroundColor = .clear
		super.viewDidLoad()
	}
	
	open var content: UIViewController? {
		get {return self.children.first}
		set {
			self.children.forEach{$0.removeFromParent()}
			self.view.subviews.forEach{$0.removeFromSuperview()}
			if let newValue = newValue {
				self.addChild(newValue)
				newValue.view.translatesAutoresizingMaskIntoConstraints = false
				self.view.addSubview(newValue.view, constraining: .allSides)
			}
		}
	}
}
#endif
