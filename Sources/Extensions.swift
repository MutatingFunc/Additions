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
	func flatMap<T>(_ keyPath: KeyPath<Element, T?>) -> [T] {
		return self.flatMap{$0[keyPath: keyPath]}
	}
	func flatMap<Sequence: Swift.Sequence>(_ keyPath: KeyPath<Element, Sequence>) -> [Sequence.Element] {
		return self.flatMap{$0[keyPath: keyPath]}
	}
}
public extension Collection {
	subscript(ifPresent index: Index) -> Iterator.Element? {
		get {return self.indices.contains(index) ? self[index] : nil}
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
public extension Comparable where Self: _Strideable, Self.Stride: SignedInteger {
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

public extension Bool {
	mutating func invert() {
		self = !self
	}
}
