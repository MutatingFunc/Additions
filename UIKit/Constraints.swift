//
//  Constraints.swift
//  StandardAdditions
//
//  Created by James Froggatt on 16.08.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

#if !swift(>=4.2)
extension NSLayoutConstraint {
	public typealias Axis = UILayoutConstraintAxis
}
#endif
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
	var heightAnchor: NSLayoutDimension {get}
	var widthAnchor: NSLayoutDimension {get}
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
	public init(_ dimensions: LayoutAnchorFrameDimension) {
		self = []
		if dimensions.contains(.height) {self.insert(.verticalSides)}
		if dimensions.contains(.width) {self.insert(.horizontalSides)}
	}
	
	public static let allSides        = [.verticalSides, .horizontalSides] as Self
	public static let verticalSides   = [.top, .bottom] as Self
	public static let horizontalSides = [.leading, .trailing] as Self
	
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
	public init(_ dimensions: LayoutAnchorFrameDimension) {
		self.rawValue = dimensions.rawValue
	}
	public init(_ axes: NSLayoutConstraint.Axis) {
		self.rawValue = LayoutAnchorFrameDimension(axes).rawValue
	}
	
	public static let center  = [centerX, centerY] as Self
	
	public static let centerX = Self(rawValue: 1 << 0)
	public static let centerY = Self(rawValue: 1 << 1)
}
@available(iOS 9, *)
public struct LayoutAnchorFrameDimension: OptionSet {
	public typealias `Self` = LayoutAnchorFrameDimension
	public let rawValue: UInt8
	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}
	public init(_ centers: LayoutAnchorFrameCenter) {
		self.rawValue = centers.rawValue
	}
	public init(_ axes: NSLayoutConstraint.Axis) {
		switch axes {case .horizontal: self = .width; case .vertical: self = .height}
	}
	
	public static let bothDimensions = [width, height] as Self
	
	public static let width  = Self(rawValue: 1 << 0)
	public static let height = Self(rawValue: 1 << 1)
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
	public typealias Dimension = LayoutAnchorFrameDimension
	
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
		if sides.contains(.right) {
			self.rightAnchor.constraint(equalTo: subview.rightAnchor, constant: padding).isActive = true
		}
		if sides.contains(.trailing) {
			self.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: padding).isActive = true
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
	
	func constrainSubview(_ subview: UIView, _ dimensions: Dimension, scale: CGFloat = 1, padding: CGFloat = 0) {
		if dimensions.contains(.width) {
			subview.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: scale, constant: -padding).isActive = true
		}
		if dimensions.contains(.height) {
			subview.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: scale, constant: -padding).isActive = true
		}
	}
	
	func constrain(_ dimensions: Dimension, to constant: CGFloat) {
		if dimensions.contains(.width) {
			self.widthAnchor.constraint(equalToConstant: constant).isActive = true
		}
		if dimensions.contains(.height) {
			self.heightAnchor.constraint(equalToConstant: constant).isActive = true
		}
	}
}
#endif
