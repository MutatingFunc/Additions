//
//  WeakAny.swift
//  Additions
//
//  Created by James Froggatt on 22.09.2016.
//
//

/*
inactive - no valid use found
*/

//private, to avoid explicit case access
private enum _WeakAny<Type> {
	case valueType(Type?)
	case referenceType(Weak<AnyObject>)
	
	init(target: Type?) {
		//this cast will succeed only if the passed target is a non-nil reference, no matter the static value of Type, as long as Foundation is not imported
		if let unwrapped = target, type(of: unwrapped) is AnyClass {
			self = .referenceType(Weak(unwrapped as AnyObject))
		} else {
			self = .valueType(target)
		}
	}
	
	var target: Type? {
		get {
			switch self {
			case .referenceType(let weak): return weak.target as? Type
			case .valueType(let value): return value
			}
		}
		set {
			self = .init(target: newValue)
		}
	}
}

///acts as a weak wrapper around a reference-type, or a regular wrapper around a value-type
public struct WeakAny<Type> {
	private var data: _WeakAny<Type>
	
	///the contained value, stored weakly if value is a reference type
	public var target: Type? {
		get {return data.target}
		set {data.target = newValue}
	}
	
	public init(_ target: Type?) {
		self.data = _WeakAny(target: target)
	}
}
