//
//  OrderedDictionary.swift
//  StandardAdditions
//
//  Created by James Froggatt on 28.06.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

///a dictionary with an ordered set of keys
public struct OrderedDictionary<Key: Hashable, Value>: RangeReplaceableCollection, ExpressibleByDictionaryLiteral, CustomStringConvertible, CustomDebugStringConvertible {
	public typealias KeyValue = (key: Key, value: Value)
	
	public fileprivate(set) var keys = [Key]()
	fileprivate var values = [Key: Value]()
	
	public init() {}
	public init(dictionaryLiteral elements: (Key, Value)...) {
		self.init(elements)
	}
	public init<C>(_ collection: C) where
			C: Collection,
			C.Iterator.Element == (Key, Value) {
		if C.IndexDistance.self == Int.self {
			keys.reserveCapacity(collection.count as! Int)
		}
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
			} else if let index = keys.index(of: key) {
				values.removeValue(forKey: key)
				keys.remove(at: index)
			}
		}
	}
	///accesses the key-value pair at the given index
	subscript(_ position: Int) -> KeyValue {
		get {
			let key = keys[position]
			return (key, values[key]!)
		}
		set {
			values.removeValue(forKey: keys[position])
			keys[position] = newValue.key
			values[newValue.key] = newValue.value
		}
	}
	
	///updates the value at the given position
	@discardableResult mutating func setValue(_ newValue: Value, at position: Int) -> Value {
		let key = keys[position]
		return values.updateValue(newValue, forKey: key)!
	}
	///updates the value for the given key, or adds a new key-value pair if the key does not exist
	@discardableResult mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
		let oldValue = values.updateValue(value, forKey: key)
		if oldValue == nil {keys.append(key)}
		return oldValue
	}
}

public extension OrderedDictionary {
	var startIndex: Int {return keys.startIndex}
	func index(after i: Int) -> Int {return i+1}
	var endIndex: Int {return keys.endIndex}
	
	var isEmpty: Bool {return keys.isEmpty}
	var underestimatedCount: Int {return keys.underestimatedCount}
	var count: Int {return keys.count}
	
	mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where
			C: Collection,
			C.Iterator.Element == KeyValue {
		let oldKeys = self.keys[subrange]
		for key in oldKeys {
			self.values[key] = nil
		}
		var newKeys = [Key]()
		if let count = newElements.count as? Int {newKeys.reserveCapacity(count)}
		for (key, value) in newElements {
			self.values[key] = value
			newKeys.append(key)
		}
		self.keys.replaceSubrange(subrange, with: newKeys)
	}
}

public extension OrderedDictionary {
	var description: String {
		return "\(OrderedDictionary.self): [" + self.keys.map{key in
			"\(key): \(self.values[key].debugDescription)"
		}.joined(separator: ", ") + "]"
	}
	var debugDescription: String {
		return self.description
	}
}
