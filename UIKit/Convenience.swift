//
//  Convenience.swift
//  StandardAdditions
//
//  Created by James Froggatt on 12.07.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

#if canImport(CoreGraphics)
	import CoreGraphics
	
	public extension CGRect {
		func insetBy(_ edgeInsets: UIEdgeInsets) -> CGRect {
			return CGRect(x: self.origin.x + edgeInsets.left, y: self.origin.y + edgeInsets.top, width: self.width - (edgeInsets.left + edgeInsets.right), height: self.height - (edgeInsets.top + edgeInsets.bottom))
		}
		func insetBy(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> CGRect {
			return insetBy(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
		}
		func insetBy(_ all: CGFloat) -> CGRect {
			return insetBy(dx: all, dy: all)
		}
	}
#endif
#if canImport(UIKit)
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
		func insertItem(at indices: IndexPath...) {
			self.insertItems(at: indices)
		}
		func deleteItem(at indices: IndexPath...) {
			self.deleteItems(at: indices)
		}
		func insertItem(at indices: Int..., in section: Int = 0) {
			self.insertItems(at: indices.map{IndexPath(row: $0, section: section)})
		}
		func deleteItem(at indices: Int..., in section: Int = 0) {
			self.deleteItems(at: indices.map{IndexPath(row: $0, section: section)})
		}
	}
	public extension UITableView {
		func insertRow(at indices: IndexPath..., with animation: UITableViewRowAnimation = .automatic) {
			self.insertRows(at: indices, with: animation)
		}
		func deleteRow(at indices: IndexPath..., with animation: UITableViewRowAnimation = .automatic) {
			self.deleteRows(at: indices, with: animation)
		}
		func insertRow(at indices: Int..., in section: Int = 0, with animation: UITableViewRowAnimation = .automatic) {
			self.insertRows(at: indices.map{IndexPath(row: $0, section: section)}, with: animation)
		}
		func deleteRow(at indices: Int..., in section: Int = 0, with animation: UITableViewRowAnimation = .automatic) {
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
