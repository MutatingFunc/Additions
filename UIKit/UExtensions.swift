//
//  UExtensions.swift
//  Additions
//
//  Created by James Froggatt on 28.06.2017.
//

import Foundation

#if os(iOS) || os(tvOS)
	public extension IndexPath {
		var uSection: UInt {return UInt(section)}
		var uRow: UInt {return UInt(row)}
		var uItem: UInt {return UInt(item)}
	}
#endif
