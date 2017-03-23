//
//  Convenience.swift
//  StandardAdditions
//
//  Created by James Froggatt on 12.07.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

#if os(iOS) || os(tvOS)
	import UIKit

	public extension UIAlertController {
		@discardableResult func addAction(if condition: Bool = true, _ title: String?, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
			if condition {self.addAction(UIAlertAction(title: title, style: style, handler: handler))}
			return self
		}
	}

	public extension UIViewController {
		@nonobjc func present(in presentingViewController: UIViewController, from source: UIBarButtonItem, animated: Bool, completion: (() -> ())? = nil) {
			self.present(in: presentingViewController, animated: animated, completion: completion)
			self.popoverPresentationController?.barButtonItem = source
		}
		@nonobjc func present(in presentingViewController: UIViewController, from source: UIView, animated: Bool, completion: (() -> ())? = nil) {
			self.present(in: presentingViewController, animated: animated, completion: completion)
			self.popoverPresentationController?.setSource(source)
		}
		
		func present(in presentingViewController: UIViewController, animated: Bool, completion: (() -> ())? = nil) {
			presentingViewController.present(self, animated: animated, completion: completion)
		}
	}
	
	public extension UITableView {
		func setSource(_ source: UITableViewDataSource & UITableViewDelegate) {
			self.dataSource = source
			self.delegate = source
		}
	}
	public extension UIPickerView {
		func setSource(_ source: UIPickerViewDataSource & UIPickerViewDelegate) {
			self.dataSource = source
			self.delegate = source
		}
	}
	
	public extension UIPopoverPresentationController {
		func setSource(_ source: UIView?) {
			self.sourceView = source
			self.sourceRect = source?.bounds ?? .zero
		}
	}
	
	public extension UIView {
		func enableAutolayout() {
			self.translatesAutoresizingMaskIntoConstraints = false
		}
		func setHidden(_ newValue: Bool, animated: Bool, duration: TimeInterval = 0.5) {
			if newValue == self.isHidden {return}
			
			switch (newValue, animated) {
			case (_, false):
				self.isHidden = newValue
			case (false, true):
				self.isHidden = false
				self.alpha = 0
				UIView.animate(withDuration: duration) {
					self.alpha = 1
				}
			case (true, true):
				UIView.animate(withDuration: duration, animations: {
					self.alpha = 0
					}, completion: {_ in
						self.isHidden = true
						self.alpha = 1
				})
			}
		}
	}
	
	public extension UIStoryboardSegue {
		var targetNav: UINavigationController? {
			return destination as? UINavigationController
		}
		var target: UIViewController? {
			return targetNav?.topViewController ?? destination
		}
		var targetPopover: UIPopoverPresentationController? {
			return destination.popoverPresentationController
		}
	}
#endif
