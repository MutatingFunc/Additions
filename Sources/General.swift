//
//  General.swift
//  Additions
//
//  Created by James Froggatt on 27.09.2016.
//
//

//functions

///runs a function, and returns it
public func runNow<Out>(_ f: @escaping () -> Out) -> () -> Out {
	_ = f()
	return f
}

///runs a function, and returns it
public func runNow<In, Out>(with value: In, _ f: @escaping (In) -> Out) -> (In) -> Out {
	_ = f(value)
	return f
}

//extensions

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
	func clamped(_ range: ClosedRange<Self>) -> Self {
		return max(min(self, range.upperBound), range.lowerBound)
	}
	
	///clamps self
	mutating func clamp(_ range: ClosedRange<Self>) {
		self = self.clamped(range)
	}
}
public extension Comparable where Self: _Strideable, Self.Stride: SignedInteger {
	///return the bound which self is beyond, otherwise self
	func clamped(_ range: CountableRange<Self>) -> Self {
		return max(min(self, range.upperBound.advanced(by: -1)), range.lowerBound)
	}
	///return the bound which self is beyond, otherwise self
	func clamped(_ range: CountableClosedRange<Self>) -> Self {
		return max(min(self, range.upperBound), range.lowerBound)
	}
	
	///clamps self
	mutating func clamp(_ range: CountableRange<Self>) {
		self = self.clamped(range)
	}
	///clamps self
	mutating func clamp(_ range: CountableClosedRange<Self>) {
		self = self.clamped(range)
	}
}

public extension Bool {
	mutating func invert() {
		self = !self
	}
}
