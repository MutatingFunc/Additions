//
//  ObjCBridgeable.swift
//  Additions
//
//  Created by James Froggatt on 22.04.2019.
//

import Foundation

@objc(ObjCBridgingContainer)
public class ObjCBridgingContainer: NSObject {
	fileprivate let value: Any
	fileprivate init(_ value: Any) {
		self.value = value
	}
}

/// Conforming types are automatically boxed to an opaque type when bridged to Objective-C. This can be useful when using @objc annotations to extend types with overridable methods, where the method is not actually meant for Objective-C usage.
public protocol ObjCBridgeable: _ObjectiveCBridgeable where _ObjectiveCType == ObjCBridgingContainer {
	///An optional sensible default to use when Objective-C sends nil from an API marked _Nonnull/nonnull. Leave as nil to use the default force-unwrap behaviour for unexpected nils.
	static var objcBridgingValueForUnexpectedNil: Self? {get}
}
public extension ObjCBridgeable where Self: ExpressibleByNilLiteral {
	static var objcBridgingValueForUnexpectedNil: Self? {return nil as Self}
}

public extension ObjCBridgeable {
	private static func bridgingCastFailureMessage(from type: Any.Type) -> String {
		return "ObjCBridgeable error: Expected value of type \(Self.self), but received value of type \(type.self) from Objective-C"
	}
	private static func bridgingNilFailureMessage() -> String {
		return "ObjCBridgeable error: Expected non-optional value of type \(Self.self), but received nil from Objective-C"
	}
	
	func _bridgeToObjectiveC() -> _ObjectiveCType {
		return _ObjectiveCType(self)
	}
	
	static func _forceBridgeFromObjectiveC(_ source: _ObjectiveCType, result: inout Self?) {
		result = source.value as? Self ?? fatalError(bridgingCastFailureMessage(from: type(of: source.value)))
	}
	
	static func _conditionallyBridgeFromObjectiveC(_ source: _ObjectiveCType, result: inout Self?) -> Bool {
		result = source.value as? Self
		return result != nil
	}
	
	static func _unconditionallyBridgeFromObjectiveC(_ source: _ObjectiveCType?) -> Self {
		if let value = source?.value {
			return value as? Self ?? fatalError(bridgingCastFailureMessage(from: type(of: value)))
		} else {
			return Self.objcBridgingValueForUnexpectedNil ?? fatalError(bridgingNilFailureMessage())
		}
	}
}
