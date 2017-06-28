//
//  UArray.swift
//  Additions
//
//  Created by James Froggatt on 28.06.2017.
//

import Foundation

public struct UArray<Element> {
	private var array: [Element]
	
	public init() {self.array = Array()}
	public init(_ array: [Element]) {self.array = array}
	
	private func unsigned(_ range: Range<UInt>) -> CountableRange<Int> {
		return Int(range.lowerBound)..<Int(range.upperBound)
	}
}
extension UArray: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: Element...) {self.init(elements)}
}
extension UArray: RangeReplaceableCollection {
	public var startIndex: UInt {return UInt(array.startIndex)}
	public var endIndex: UInt {return UInt(array.endIndex)}
	public func index(after i: UInt) -> UInt {return i + 1}
	public mutating func reserveCapacity(_ n: Int) {array.reserveCapacity(n)}
	public mutating func reserveCapacity(_ n: UInt) {array.reserveCapacity(Int(n))}
	public var count: UInt {return endIndex - startIndex}
	
	public mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C: Collection, R: RangeExpression, Element == C.Element, UInt == R.Bound {
		let subrange = subrange.relative(to: self)
		array.replaceSubrange(unsigned(subrange.relative(to: self)), with: newElements)
	}
}
extension UArray: MutableCollection {
	public subscript(position: UInt) -> Element {
		get {return array[Int(position)]}
		set {array[Int(position)] = newValue}
	}
}
extension UArray: RandomAccessCollection {
	public typealias SubSequence = MutableRangeReplaceableRandomAccessSlice<UArray>
	
	public func index(_ i: UInt, offsetBy n: Int) -> UInt {return i.advanced(by: n)}
	public func distance(from start: UInt, to end: UInt) -> Int {return start.distance(to: end)}
	
	public subscript(bounds: Range<UInt>) -> RandomAccessSlice<UArray<Element>> {
		get {return RandomAccessSlice(base: self, bounds: bounds)}
		set {self.replaceSubrange(bounds, with: newValue)}
	}
}
extension UArray {
	public var underestimatedCount: Int {return array.underestimatedCount}
}

extension UArray: Codable {
	public init(from decoder: Decoder) throws {self.array = try Array(from: decoder)}
	public func encode(to encoder: Encoder) throws {try array.encode(to: encoder)}
}

extension UArray: CustomStringConvertible, CustomDebugStringConvertible {
	public var description: String {return array.description}
	public var debugDescription: String {return array.debugDescription}
}

/*
CustomDebugStringConvertible
CustomReflectable
CustomStringConvertible
CVarArg
*/
