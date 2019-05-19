//
//  Identifier.swift
//  Additions
//
//  Created by James Froggatt on 19.05.2019.
//

import Foundation

public protocol Identifiable {
	associatedtype RawIdentifier: Codable = String
	
	var id: Identifier<Self> {get}
}

public struct Identifier<Value: Identifiable>: RawRepresentable {
	public let rawValue: Value.RawIdentifier
	public init(rawValue: Value.RawIdentifier) {self.rawValue = rawValue}
}

extension Identifier: Codable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		rawValue = try container.decode(Value.RawIdentifier.self)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawValue)
	}
}

extension Identifier: CustomStringConvertible
where Value.RawIdentifier: CustomStringConvertible {
	public var description: String {return rawValue.description}
}

extension Identifier: CustomDebugStringConvertible
where Value.RawIdentifier: CustomDebugStringConvertible {
	public var debugDescription: String {return rawValue.debugDescription}
}

extension Identifier: ExpressibleByUnicodeScalarLiteral
where Value.RawIdentifier: ExpressibleByUnicodeScalarLiteral {
	public init(unicodeScalarLiteral value: Value.RawIdentifier.UnicodeScalarLiteralType) {
		self.rawValue = Value.RawIdentifier(unicodeScalarLiteral: value)
	}
}

extension Identifier: ExpressibleByExtendedGraphemeClusterLiteral
where Value.RawIdentifier: ExpressibleByExtendedGraphemeClusterLiteral {
	public init(extendedGraphemeClusterLiteral value: Value.RawIdentifier.ExtendedGraphemeClusterLiteralType) {
		self.rawValue = Value.RawIdentifier(extendedGraphemeClusterLiteral: value)
	}
}

extension Identifier: ExpressibleByStringLiteral
where Value.RawIdentifier: ExpressibleByStringLiteral {
	public init(stringLiteral value: Value.RawIdentifier.StringLiteralType) {
		self.rawValue = Value.RawIdentifier(stringLiteral: value)
	}
}

extension Identifier: ExpressibleByIntegerLiteral
where Value.RawIdentifier: ExpressibleByIntegerLiteral {
	public init(integerLiteral value: Value.RawIdentifier.IntegerLiteralType) {
		self.rawValue = Value.RawIdentifier(integerLiteral: value)
	}
}

extension Identifier: ExpressibleByNilLiteral
where Value.RawIdentifier: ExpressibleByNilLiteral {
	public init(nilLiteral: ()) {self.rawValue = Value.RawIdentifier(nilLiteral: nilLiteral)}
}
