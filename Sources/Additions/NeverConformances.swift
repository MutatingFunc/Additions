//
//  NeverConformances.swift
//  Additions
//
//  Created by James Froggatt on 24.05.2018.
//

import Foundation

extension Never: CustomStringConvertible {
	public var description: String {switch self {}}
}
extension Never: RandomAccessCollection, MutableCollection {
	public var startIndex: Never {switch self {}}
	public var endIndex: Never {switch self {}}
	public func index(before i: Index) -> Index {}
	public func index(after i: Never) -> Index {}
	public func index(_ i: Never, offsetBy n: Int) -> Never {}
	public subscript(position: Never) -> () {
		get {}
		set {}
	}
}/*
extension Never: Strideable {
	public func advanced(by n: Int) -> Never {switch self {}}
	public func distance(to other: Never) -> Int {switch self {}}
}*/
