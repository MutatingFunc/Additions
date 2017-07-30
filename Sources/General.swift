//
//  General.swift
//  Additions
//
//  Created by James Froggatt on 08.06.2017.
//

import Foundation

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

//Adrian Zubarev, Swift Evolution, Jun 27, 2017
public func ??<T>(optional: T?, noreturnOrError: @autoclosure () throws -> Never) rethrows -> T {
	switch optional {
	case .some(let value): return value
	case .none: try noreturnOrError()
	}
}

public struct NSObjectHashable<Object: NSObjectProtocol>: Hashable {
	public var object: Object
	public init(_ object: Object) {self.object = object}
	
	public var hashValue: Int {return ObjectIdentifier(object).hashValue}
	public static func ==(a: NSObjectHashable, b: NSObjectHashable) -> Bool {
		return a.object === b.object
	}
}
