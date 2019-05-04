//
//  Weak.swift
//  StandardAdditions
//
//  Created by James Froggatt on 25.04.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

///a weak wrapper around a reference-type
public struct Weak<Reference: AnyObject> {
	public weak var target: Reference?
	public init(_ target: Reference?) {self.target = target}
}
extension Weak: ExpressibleByNilLiteral {
	public init(nilLiteral: ()) {target = nil}
}
extension Weak: Hashable {
	public static func ==(lhs: Weak<Reference>, rhs: Weak<Reference>) -> Bool {
		return lhs.target === rhs.target
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(target.flatMap(ObjectIdentifier.init))
	}
}
extension Weak: CustomDebugStringConvertible {
	public var debugDescription: String {return target.debugDescription}
}
