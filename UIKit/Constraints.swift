//
//  Constraints.swift
//  StandardAdditions
//
//  Created by James Froggatt on 16.08.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

#if canImport(UIKit)
import UIKit

@available(iOS 9, *)
public protocol LayoutAnchorFrame {
	var topAnchor: NSLayoutYAxisAnchor {get}
	var bottomAnchor: NSLayoutYAxisAnchor {get}
	var centerYAnchor: NSLayoutYAxisAnchor {get}
	var centerXAnchor: NSLayoutXAxisAnchor {get}
	var leadingAnchor: NSLayoutXAxisAnchor {get}
	var trailingAnchor: NSLayoutXAxisAnchor {get}
	var leftAnchor: NSLayoutXAxisAnchor {get}
	var rightAnchor: NSLayoutXAxisAnchor {get}
}
@available(iOS 9, *)
extension UIView: LayoutAnchorFrame {}
@available(iOS 9, *)
extension UILayoutGuide: LayoutAnchorFrame {}

@available(iOS 9, *)
public struct LayoutAnchorFrameSide: OptionSet {
	public typealias `Self` = LayoutAnchorFrameSide
	public let rawValue: UInt8
	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}
	
	public static let allSides = Self(rawValue: (1 << 4) - 1)
	
	public static let top      = Self(rawValue: 1 << 0)
	public static let bottom   = Self(rawValue: 1 << 1)
	public static let leading  = Self(rawValue: 1 << 2)
	public static let trailing = Self(rawValue: 1 << 3)
	public static let left     = Self(rawValue: 1 << 4)
	public static let right    = Self(rawValue: 1 << 5)
}
@available(iOS 9, *)
public struct LayoutAnchorFrameCenter: OptionSet {
	public typealias `Self` = LayoutAnchorFrameCenter
	public let rawValue: UInt8
	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}
	
	public static let center  = Self(rawValue: (1 << 2) - 1)
	
	public static let centerX = Self(rawValue: 1 << 0)
	public static let centerY = Self(rawValue: 1 << 1)
}

@available(iOS 9, *)
public extension UIView {
	func addSubview(_ subview: UIView, constraining sides: Side, padding: CGFloat = 0) {
		addSubview(subview, constraining: sides, to: self, padding: padding)
	}
	func addSubview(_ subview: UIView, constraining centers: Center, offset: CGFloat = 0) {
		addSubview(subview, constraining: centers, to: self, offset: offset)
	}
	func addSubview(_ subview: UIView, constraining sides: Side, to frame: LayoutAnchorFrame, padding: CGFloat = 0) {
		self.addSubview(subview)
		frame.constrainSubview(subview, sides, padding: padding)
	}
	func addSubview(_ subview: UIView, constraining centers: Center, to frame: LayoutAnchorFrame, offset: CGFloat = 0) {
		self.addSubview(subview)
		self.constrainSubview(subview, centers, offset: offset)
	}
}

@available(iOS 9, *)
public extension LayoutAnchorFrame {
	public typealias Side = LayoutAnchorFrameSide
	public typealias Center = LayoutAnchorFrameCenter
	
	@available(*, deprecated, renamed: "constrainSubview(_:_:padding:)")
	func constrain(subview: UIView, _ sides: Side, padding: CGFloat = 0) {constrainSubview(subview, sides, padding: padding)}
	func constrainSubview(_ subview: UIView, _ sides: Side, padding: CGFloat = 0) {
		if sides.contains(.top) {
			subview.topAnchor.constraint(equalTo: self.topAnchor, constant: padding).isActive = true
		}
		if sides.contains(.left) {
			subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding).isActive = true
		}
		if sides.contains(.leading) {
			subview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding).isActive = true
		}
		if sides.contains(.bottom) {
			self.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: padding).isActive = true
		}
		if sides.contains(.trailing) {
			self.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: padding).isActive = true
		}
		if sides.contains(.right) {
			subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: padding).isActive = true
		}
	}
	@available(*, deprecated, renamed: "constrainSubview(_:_:offset:)")
	func constrain(subview: UIView, _ centers: Center, offset: CGFloat = 0) {constrainSubview(subview, centers, offset: offset)}
	func constrainSubview(_ subview: UIView, _ centers: Center, offset: CGFloat = 0) {
		if centers.contains(.centerX) {
			subview.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: offset).isActive = true
		}
		if centers.contains(.centerY) {
			subview.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: offset).isActive = true
		}
	}
}
#endif
