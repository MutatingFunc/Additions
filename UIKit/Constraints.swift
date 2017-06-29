//
//  Constraints.swift
//  StandardAdditions
//
//  Created by James Froggatt on 16.08.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

#if os(iOS) || os(tvOS)
	import UIKit

	@available(iOS 9, *)
	public extension UIView {
		struct Side: OptionSet {
			public let rawValue: UInt8
			public init(rawValue: UInt8) {
				self.rawValue = rawValue
			}
			
			public static let allSides = Side(rawValue: (1 << 4) - 1)
			
			public static let top      = Side(rawValue: 1 << 0)
			public static let bottom   = Side(rawValue: 1 << 1)
			public static let leading  = Side(rawValue: 1 << 2)
			public static let trailing = Side(rawValue: 1 << 3)
		}
		struct Center: OptionSet {
			public let rawValue: UInt8
			public init(rawValue: UInt8) {
				self.rawValue = rawValue
			}
			
			public static let center = Center(rawValue: (1 << 2) - 1)
			
			public static let centerX = Center(rawValue: 1 << 0)
			public static let centerY = Center(rawValue: 1 << 1)
		}
		
		func addSubview(_ subview: UIView, constraining sides: Side, padding: CGFloat = 0) {
			self.addSubview(subview)
			self.constrain(subview: subview, sides, padding: padding)
		}
		func addSubview(_ subview: UIView, constraining centers: Center, offset: CGFloat = 0) {
			self.addSubview(subview)
			self.constrain(subview: subview, centers, offset: offset)
		}
		
		func constrain(subview: UIView, _ sides: Side, padding: CGFloat = 0) {
			if sides.contains(.top) {
				subview.topAnchor.constraint(equalTo: self.topAnchor, constant: padding).isActive = true
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
		}
		func constrain(subview: UIView, _ centers: Center, offset: CGFloat = 0) {
			if centers.contains(.centerX) {
				subview.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: offset)
			}
			if centers.contains(.centerY) {
				subview.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: offset)
			}
		}
	}
#endif
