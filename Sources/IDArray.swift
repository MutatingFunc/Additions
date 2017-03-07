//
//  IDArray.swift
//  StandardAdditions
//
//  Created by James Froggatt on 14.06.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

import Foundation
#if swift(>=3.0)
	//unexpected compilation error in Swift 3.1
#else
public typealias IDPaired<Element> = (id: UUID, value: Element)

///a collection providing unique identifiers for its contents
public struct IDArray<Element>: RangeReplaceableCollection, MutableCollection, ExpressibleByArrayLiteral, CustomStringConvertible, CustomDebugStringConvertible {
	
	fileprivate var data = OrderedDictionary<UUID, Element>()
	
	public init() {}
	public init(arrayLiteral elements: Element...) {self.init(elements)}
	public init<S>(_ collection: S) where
			S: Sequence, S.Iterator.Element == Element {
		for element in collection {
			self.data.append((UUID(), element))
		}
	}
}

public extension IDArray {
	///accesses the element at the given position
	subscript(_ position: Int) -> Element {
		get {return data[position].value}
		set {data.setValue(newValue, at: position)}
	}
	///accesses the element with the given identifier
	subscript(_ id: UUID) -> Element? {
		get {return data[id]}
		set {data[id] = newValue}
	}
	///returns the index for the given ID
	func index(ofID id: UUID) -> Int? {
		return data.keys.index(of: id)
	}
	///returns the id and value at the given index
	func idPaired(at position: Int) -> IDPaired<Element> {
		return data[position] as (UUID, Element)
	}
	
	func contains(id: UUID) -> Bool {
		return data[id] != nil
	}
}

public extension IDArray {
	var startIndex: Int {return data.startIndex}
	func index(after i: Int) -> Int {return i+1}
	var endIndex: Int {return data.endIndex}
	
	var isEmpty: Bool {return data.isEmpty}
	var underestimatedCount: Int {return data.underestimatedCount}
	var count: Int {return data.count}
	
	mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where
			C: Collection, C.Iterator.Element == Element {
		data.replaceSubrange(subrange, with: newElements.map{(UUID(), $0)})
	}
}

public extension IDArray {
	public var description: String {
		return "\(IDArray.self): [" + data.map{"\($0.value)"}.joined(separator: ", ") + "]"
	}
	public var debugDescription: String {
		return self.description
	}
}
#endif
