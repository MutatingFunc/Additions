//
//  UExtensions.swift
//  Additions
//
//  Created by James Froggatt on 28.06.2017.
//

/*
inactive - working against language
*/

import Foundation

#if canImport(UIKit) && !os(watchOS)
public extension IndexPath {
	var uSection: UInt {return UInt(section)}
	var uRow: UInt {return UInt(row)}
	var uItem: UInt {return UInt(item)}
}
#endif
