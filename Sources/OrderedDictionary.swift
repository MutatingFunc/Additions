//
//  OrderedDictionary.swift
//  StandardAdditions
//
//  Created by James Froggatt on 28.06.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

///a dictionary with an ordered set of keys
public struct OrderedDictionary<Key: Hashable, Value>: ExpressibleByDictionaryLiteral {
	public typealias KeyValue = (key: Key, value: Value)
	
	public private(set) var keys = [Key]()
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

public extension OrderedDictionary {
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
	@discardableResult mutating func updateValue(_ newValue: Value, at position: Int) -> Value {
		return values.updateValue(newValue, forKey: keys[position])! //safe use of indexed key
	}
	
	///updates the value for the given key, or adds a new key-value pair if the key does not exist
	@discardableResult mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
		let oldValue = values.updateValue(value, forKey: key)
		if oldValue == nil {keys.append(key)}
		return oldValue
	}
	///removes the value for the given key
	@discardableResult mutating func removeValue(forKey key: Key) -> (index: Int, value: Value)? {
		guard
			values[key] != nil, //O(1) failure shortcut
			let index = keys.index(of: key)
		else {return nil}
		keys.remove(at: index)
		return values.removeValue(forKey: key).map{(index, $0)}
	}
}

extension OrderedDictionary: RangeReplaceableCollection {}
public extension OrderedDictionary {
	var startIndex: Int {return keys.startIndex}
	var endIndex: Int {return keys.endIndex}
	func index(after i: Int) -> Int {return i+1}
	public mutating func reserveCapacity(_ n: Int) {
		keys.reserveCapacity(n)
		values.reserveCapacity(n)
	}
	
	var underestimatedCount: Int {return keys.underestimatedCount}
	
	///accesses the key-value pair at the given index
	subscript(_ position: Int) -> KeyValue {
		get {
			let key = keys[position]
			return (key, values[key]!) //safe use of indexed key
		}
		set {
			self.replaceSubrange(position...position, with: CollectionOfOne(newValue))
		}
	}
	mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where
			C: Collection, R: RangeExpression, Element == C.Element, Int == R.Bound {
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
extension OrderedDictionary: RandomAccessCollection {
	public typealias SubSequence = RangeReplaceableRandomAccessSlice<OrderedDictionary>
	public func index(_ i: Int, offsetBy n: Int) -> Int {return i.advanced(by: n)}
	public func distance(from start: Int, to end: Int) -> Int {return start.distance(to: end)}
}

extension OrderedDictionary: CustomStringConvertible, CustomDebugStringConvertible {
	public var description: String {
		return "\(OrderedDictionary.self): [" + self.keys.map {key in
			"\(key): \(self.values[key].debugDescription)"
		}.joined(separator: ", ") + "]"
	}
	public var debugDescription: String {
		return self.description
	}
}

private let uniqueKeyRequired = "Inserted keys must be unique"
