//
//  ObjCAssociatedObjects.swift
//  Additions
//
//  Created by James Froggatt on 31.05.2019.
//

import Foundation

public extension NSObject {
	@usableFromInline
	internal static func pointer(for key: String) -> UnsafeRawPointer {
		return UnsafeRawPointer(bitPattern: key.hashValue)!
	}
	
	/// A String-based accessor for ObjC associated objects. The default association policy is .retain.
	///
	/// - Parameter key: The string key with which to look up the object.
	@inlinable
	subscript(associatedObject key: String) -> Any? {
		get {return objc_getAssociatedObject(self, NSObject.pointer(for: key))}
		set {self[associatedObject: key, .retain] = newValue}
	}
	
	/// A String-based accessor for ObjC associated objects. The default association policy is .retain.
	///
	/// - Parameters:
	///   - key: The string key with which to look up the object.
	///   - policy: The association policy to use.
	@inlinable
	subscript(associatedObject key: String, policy: AssociationPolicy) -> Any? {
		get {return self[associatedObject: key]}
		set {self[associatedObject: key, objc: policy.objc] = newValue}
	}
	
	/// A String-based accessor for ObjC associated objects. The default association policy is .retain.
	///
	/// - Parameters:
	///   - key: The string key with which to look up the object.
	///   - policy: The association policy to use.
	@inlinable
	subscript(associatedObject key: String, objc policy: objc_AssociationPolicy) -> Any? {
		get {return self[associatedObject: key]}
		set {objc_setAssociatedObject(self, NSObject.pointer(for: key), newValue, policy)}
	}
	
	/**
	* Policies related to associative references.
	* These are options to nsobject[associatedObject:_:]
	*/
	enum AssociationPolicy {
		/**< Specifies a weak reference to the associated object. */
		case assign
		
		/**< Specifies a strong reference to the associated object.
		*   The association is not made atomically. */
		case retainNonatomic
		
		/**< Specifies that the associated object is copied.
		*   The association is not made atomically. */
		case copyNonatomic
		
		/**< Specifies a strong reference to the associated object.
		*   The association is made atomically. */
		case retain
		
		/**< Specifies that the associated object is copied.
		*   The association is made atomically. */
		case copy
		
		/// Intialise with an equivalent objc_AssociationPolicy.
		///
		/// - Parameter objc: The underlying value to map from.
		public init?(_ objc: objc_AssociationPolicy) {
			switch objc {
			case .OBJC_ASSOCIATION_ASSIGN: self = .assign
			case .OBJC_ASSOCIATION_RETAIN_NONATOMIC: self = .retainNonatomic
			case .OBJC_ASSOCIATION_COPY_NONATOMIC: self = .copyNonatomic
			case .OBJC_ASSOCIATION_RETAIN: self = .retain
			case .OBJC_ASSOCIATION_COPY: self = .copy
			@unknown case _: return nil
			}
		}
		
		/// Returns the equivalent objc_AssociationPolicy.
		public var objc: objc_AssociationPolicy {
			switch self {
			case .assign: return .OBJC_ASSOCIATION_ASSIGN
			case .retainNonatomic: return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
			case .copyNonatomic: return .OBJC_ASSOCIATION_COPY_NONATOMIC
			case .retain: return .OBJC_ASSOCIATION_RETAIN
			case .copy: return .OBJC_ASSOCIATION_COPY
			}
		}
	}
}
