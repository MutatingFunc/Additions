//
//  Convenience.swift
//  StandardAdditions
//
//  Created by James Froggatt on 12.07.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

#if !swift(>=4.2)
extension UIAlertController {
	public typealias Style = UIAlertControllerStyle
}
extension UIAlertAction {
	public typealias Style = UIAlertActionStyle
}
extension UITableView {
	public typealias RowAnimation = UITableViewRowAnimation
}
#endif

#if canImport(CoreGraphics)
import CoreGraphics

public extension CGRect {
	func insetBy(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> CGRect {
		return CGRect(x: self.origin.x + left, y: self.origin.y + top, width: self.width - (left + right), height: self.height - (top + bottom))
	}
	func insetBy(_ all: CGFloat) -> CGRect {
		return insetBy(dx: all, dy: all)
	}
}
#endif
#if canImport(UIKit)
import UIKit

public extension CGRect {
	func insetBy(_ edgeInsets: UIEdgeInsets) -> CGRect {
		return insetBy(top: edgeInsets.top, left: edgeInsets.left, bottom: edgeInsets.bottom, right: edgeInsets.right)
	}
}
public extension UIAlertController {
	convenience init(_ title: String?, detail: String? = nil, style: UIAlertController.Style = .alert) {
		self.init(title: title, message: detail, preferredStyle: style)
	}
	@discardableResult func addAction(_ title: String?, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
		self.addAction(UIAlertAction(title: title, style: style, handler: handler))
		return self
	}
	@discardableResult func addAction(if condition: Bool, _ title: String?, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
		if condition {self.addAction(UIAlertAction(title: title, style: style, handler: handler))}
		return self
	}
}

public extension UIViewController {
	@nonobjc func present(in presentingViewController: UIViewController, from source: UIBarButtonItem, animated: Bool, completion: (() -> ())? = nil) {
		self.modalPresentationStyle = .popover
		self.present(in: presentingViewController, animated: animated, completion: completion)
		self.popoverPresentationController?.barButtonItem = source
	}
	@nonobjc func present(in presentingViewController: UIViewController, from source: UIView, animated: Bool, completion: (() -> ())? = nil) {
		self.modalPresentationStyle = .popover
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
	func insertRow(at indices: IndexPath..., with animation: UITableView.RowAnimation = .automatic) {
		self.insertRows(at: indices, with: animation)
	}
	func deleteRow(at indices: IndexPath..., with animation: UITableView.RowAnimation = .automatic) {
		self.deleteRows(at: indices, with: animation)
	}
	func insertRow(at indices: Int..., in section: Int = 0, with animation: UITableView.RowAnimation = .automatic) {
		self.insertRows(at: indices.map{IndexPath(row: $0, section: section)}, with: animation)
	}
	func deleteRow(at indices: Int..., in section: Int = 0, with animation: UITableView.RowAnimation = .automatic) {
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
