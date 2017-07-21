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
		@discardableResult func addAction(_ title: String?, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
			self.addAction(UIAlertAction(title: title, style: style, handler: handler))
			return self
		}
		@discardableResult func addAction(if condition: Bool, _ title: String?, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
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
	
	public extension UIPopoverPresentationController {
		func setSource(_ source: UIView?) {
			self.sourceView = source
			self.sourceRect = source?.bounds ?? .zero
		}
	}
	
	public extension UIView {
		@discardableResult func autolayout() -> Self {
			self.translatesAutoresizingMaskIntoConstraints = false
			return self
		}
	}
	
	public extension UICollectionView {
		func insertItems(at indices: Int..., in section: Int = 0) {
			self.insertItems(at: indices.map{IndexPath(row: $0, section: section)})
		}
		func deleteItems(at indices: Int..., in section: Int = 0) {
			self.deleteItems(at: indices.map{IndexPath(row: $0, section: section)})
		}
	}
	public extension UITableView {
		func insertRows(at indices: Int..., in section: Int = 0, with animation: UITableViewRowAnimation = .automatic) {
			self.insertRows(at: indices.map{IndexPath(row: $0, section: section)}, with: animation)
		}
		func deleteRows(at indices: Int..., in section: Int = 0, with animation: UITableViewRowAnimation = .automatic) {
			self.deleteRows(at: indices.map{IndexPath(row: $0, section: section)}, with: animation)
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
