//
//  UOrderedDictionary.swift
//  StandardAdditions
//
//  Created by James Froggatt on 28.06.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

/*
inactive - working against language
*/

///a dictionary with an ordered set of keys
public struct UOrderedDictionary<Key: Hashable, Value>: ExpressibleByDictionaryLiteral {
	public typealias KeyValue = (key: Key, value: Value)
	
	public private(set) var keys = UArray<Key>()
	private(set) var values = [Key: Value]()
	
	public init() {}
	public init(dictionaryLiteral elements: (Key, Value)...) {
		self.init(elements)
	}
	public init<C>(_ collection: C) where
			C: Collection,
			C.Iterator.Element == (Key, Value) {
		for (key, value) in collection {
			values[key] = value
			keys.append(key)
		}
	}
	public init<C>(_ collection: C) where
			C: RandomAccessCollection,
			C.Iterator.Element == (Key, Value) {
		keys.reserveCapacity(Int(collection.count))
		for (key, value) in collection {
			values[key] = value
			keys.append(key)
		}
	}
}

public extension UOrderedDictionary {
	///accesses the value for the given key,
	///with nil indicating the absence of a value
	subscript(_ key: Key) -> Value? {
		get {return values[key]}
		set {
			if let newValue = newValue {
				self.updateValue(newValue, forKey: key)
			} else {
				self.removeValue(forKey: key)
			}
		}
	}
	
	///updates the value at the given position
	@discardableResult mutating func updateValue(_ newValue: Value, at position: UInt) -> Value {
		return values.updateValue(newValue, forKey: keys[position])! //safe use of indexed key
	}
	
	///updates the value for the given key, or adds a new key-value pair if the key does not exist
	@discardableResult mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
		let oldValue = values.updateValue(value, forKey: key)
		if oldValue == nil {keys.append(key)}
		return oldValue
	}
	///removes the value for the given key
	@discardableResult mutating func removeValue(forKey key: Key) -> (index: UInt, value: Value)? {
		guard
			values[key] ¬= nil, //O(1) failure shortcut
			let index = keys.index(of: key)
		else {return nil}
		keys.remove(at: index)
		return values.removeValue(forKey: key).map{(index, $0)}
	}
}

extension UOrderedDictionary: RangeReplaceableCollection {}
public extension UOrderedDictionary {
	var startIndex: UInt {return keys.startIndex}
	var endIndex: UInt {return keys.endIndex}
	func index(after i: UInt) -> UInt {return i+1}
	public mutating func reserveCapacity(_ n: Int) {
		keys.reserveCapacity(n)
		values.reserveCapacity(n)
	}
	
	var underestimatedCount: Int {return keys.underestimatedCount}
	
	///accesses the key-value pair at the given index
	subscript(_ position: UInt) -> KeyValue {
		get {
			let key = keys[position]
			return (key, values[key]!) //safe use of indexed key
		}
	}
	mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where
			C: Collection, R: RangeExpression, Element == C.Element, UInt == R.Bound {
		for key in self.keys[subrange] {
			self.values.removeValue(forKey: key)
		}
		let keys = newElements.map {(key, value) -> Key in
			precondition(values[key] == nil, uniqueKeyRequired)
			values[key] = value
			return key
		}
		self.keys.replaceSubrange(subrange, with: keys)
	}
}
extension UOrderedDictionary: RandomAccessCollection {
	public typealias SubSequence = RangeReplaceableRandomAccessSlice<UOrderedDictionary>
	public func index(_ i: UInt, offsetBy n: Int) -> UInt {return i.advanced(by: n)}
	public func distance(from start: UInt, to end: UInt) -> Int {return start.distance(to: end)}
}

extension UOrderedDictionary: CustomStringConvertible, CustomDebugStringConvertible {
	public var description: String {
		return "\(UOrderedDictionary.self): [" + self.keys.map {key in
			"\(key): \(self.values[key].debugDescription)"
		}.joined(separator: ", ") + "]"
	}
	public var debugDescription: String {
		return self.description
	}
}

public extension UOrderedDictionary {
	init(_ orderedDictionary: OrderedDictionary<Key, Value>) {
		self.keys = UArray(orderedDictionary.keys)
		self.values = orderedDictionary.values
	}
}

private let uniqueKeyRequired = "Inserted keys must be unique"
