//
//  ClosureExtensions.swift
//  Additions
//
//  Created by James Froggatt on 16.04.2019.
//

#if canImport(UIKit)
import UIKit


internal class UIHandler: NSObject {
	internal static let defaultID = "UIHandler ID"
	internal static func id(for event: UIControl.Event) -> String {
		return "\(event.rawValue)"
	}
	
	private let handler: () -> ()
	fileprivate init(_ handler: @escaping () -> ()) {
		self.handler = handler
		super.init()
	}
	
	@objc internal func handle() {
		handler()
	}
}

public extension UIControl {
	func addHandler(for event: UIControl.Event, _ handler: @escaping () -> ()) {
		let id = UIHandler.id(for: event)
		let handler = UIHandler(handler)
		self[associatedObject: id] = handler
		self.addTarget(handler, action: #selector(handler.handle), for: event)
	}
	
	@discardableResult
	func removeHandler(for event: UIControl.Event) -> Bool {
		let id = UIHandler.id(for: event)
		if let handler = self[associatedObject:  id] as? UIHandler {
			self.removeTarget(handler, action: #selector(handler.handle), for: event)
			self[associatedObject: id] = nil
			return true
		} else {
			return false
		}
	}
}

public extension UITapGestureRecognizer {
	convenience init(handler: @escaping () -> ()) {
		self.init(target: nil, action: nil)
		addHandler(handler)
	}
}
public extension UILongPressGestureRecognizer {
	convenience init(handler: @escaping () -> ()) {
		self.init(target: nil, action: nil)
		addHandler(handler)
	}
}
public extension UIGestureRecognizer {
	func addHandler(_ handler: @escaping () -> ()) {
		let id = UIHandler.defaultID
		let handler = UIHandler(handler)
		self[associatedObject: id] = handler
		self.addTarget(handler, action: #selector(handler.handle))
	}
	
	@discardableResult
	func removeHandler() -> Bool {
		let id = UIHandler.defaultID
		guard let handler = self[associatedObject: id] as? UIHandler else {return false}
		self.removeTarget(handler, action: #selector(handler.handle))
		self[associatedObject: id] = nil
		return true
	}
}

public extension UIBarButtonItem {
	convenience init(barButtonSystemItem: UIBarButtonItem.SystemItem, handler: @escaping () -> ()) {
		self.init(barButtonSystemItem: barButtonSystemItem, target: nil, action: nil)
		setHandler(handler)
	}
	convenience init(image: UIImage?, style: UIBarButtonItem.Style, handler: @escaping () -> ()) {
		self.init(image: image, style: style, target: nil, action: nil)
		setHandler(handler)
	}
	convenience init(title: String?, style: UIBarButtonItem.Style, handler: @escaping () -> ()) {
		self.init(title: title, style: style, target: nil, action: nil)
		setHandler(handler)
	}
	
	func setHandler(_ handler: @escaping () -> ()) {
		let id = UIHandler.defaultID
		let handler = UIHandler(handler)
		self[associatedObject: id] = handler
		self.target = handler
		self.action = #selector(handler.handle)
	}
	
	@discardableResult
	func removeHandler() -> Bool {
		let id = UIHandler.defaultID
		guard self[associatedObject: id] != nil else {return false}
		self.target = nil
		self.action = nil
		self[associatedObject: id] = nil
		return true
	}
}
#endif
