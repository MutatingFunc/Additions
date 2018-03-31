//
//  Extensions.swift
//  Additions
//
//  Created by James Froggatt on 27.09.2016.
//
//

public extension Optional {
	func map<T>(_ keyPath: KeyPath<Wrapped, T>) -> T? {
		return self.map{$0[keyPath: keyPath]}
	}
	func flatMap<T>(_ keyPath: KeyPath<Wrapped, T?>) -> T? {
		return self.flatMap{$0[keyPath: keyPath]}
	}
}
public extension Sequence {
	func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
		return self.map{$0[keyPath: keyPath]}
	}
	func compactMap<T>(_ keyPath: KeyPath<Element, T?>) -> [T] {
		return self.compactMap{$0[keyPath: keyPath]}
	}
	func flatMap<Sequence: Swift.Sequence>(_ keyPath: KeyPath<Element, Sequence>) -> [Sequence.Element] {
		return self.flatMap{$0[keyPath: keyPath]}
	}
}
public extension Collection {
	subscript(ifPresent index: Index) -> Iterator.Element? {
		get {return self.indices.contains(index) ? self[index] : nil}
	}
	func partitioned<Key>(_ predicate: (Element) -> Key) -> Dictionary<Key, [Element]> {
		return Dictionary(grouping: self, by: predicate)
	}
	func partitioned<Key>(_ predicate: KeyPath<Element, Key>) -> Dictionary<Key, [Element]> {
		return Dictionary(grouping: self, by: {$0[keyPath: predicate]})
	}
}

public extension RangeReplaceableCollection {
	///removes the element at the source index and inseerts it at the destination
	mutating func move(from fromIndex: Index, to toIndex: Index) {
		insert(remove(at: fromIndex), at: toIndex)
	}
}

public extension Comparable {
	///return the bound which self is beyond, otherwise self
	func clamped(to range: ClosedRange<Self>) -> Self {
		return max(min(self, range.upperBound), range.lowerBound)
	}
	
	///clamps self
	mutating func clamp(to range: ClosedRange<Self>) {
		self = self.clamped(to: range)
	}
}

public extension Comparable where Self: Strideable, Self.Stride: SignedInteger {
	///return the bound which self is beyond, otherwise self
	func clamped(to range: CountableRange<Self>) -> Self {
		return max(min(self, range.upperBound.advanced(by: -1)), range.lowerBound)
	}
	///return the bound which self is beyond, otherwise self
	func clamped(to range: CountableClosedRange<Self>) -> Self {
		return max(min(self, range.upperBound), range.lowerBound)
	}
	
	///clamps self
	mutating func clamp(to range: CountableRange<Self>) {
		self = self.clamped(to: range)
	}
	///clamps self
	mutating func clamp(to range: CountableClosedRange<Self>) {
		self = self.clamped(to: range)
	}
}

private struct AllFWI<Index: FixedWidthInteger>: Collection {
	subscript(position: Index) -> () {return ()}
	var startIndex: Index {return Index.min}
	var endIndex: Index {return Index.max}
	func index(after i: Index) -> Index {return i.advanced(by: 1)}
}
public extension FixedWidthInteger {
	func clamped<Range>(to range: Range) -> Self where Range: RangeExpression, Range.Bound == Self {
		let range = range.relative(to: AllFWI<Self>())
		switch self {
		case range: return self
		case ...range.lowerBound: return range.lowerBound
		case _: return range.upperBound.advanced(by: -1)
		}
	}
}

private struct AllFP<Index: FloatingPoint>: Collection {
	subscript(position: Index) -> () {return ()}
	var startIndex: Index {return -Index.greatestFiniteMagnitude}
	var endIndex: Index {return Index.greatestFiniteMagnitude}
	func index(after i: Index) -> Index {return i.advanced(by: 1)}
}
public extension FloatingPoint {
	func clamped<Range>(to range: Range) -> Self where Range: RangeExpression, Range.Bound == Self {
		let range = range.relative(to: AllFP<Self>())
		switch self {
		case range: return self
		case ...range.lowerBound: return range.lowerBound
		case _: return range.upperBound.advanced(by: -1)
		}
	}
}

public extension Bool {
	@available(*, deprecated, renamed: "toggle")
	mutating func invert() {self = !self}
}
