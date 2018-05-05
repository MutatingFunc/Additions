//
//  Operators.swift
//  Additions
//
//  Created by James Froggatt on 01.11.2016.
//
//

import Foundation

/*
inactive
• code produced would be incompatible with Additions-free projects
• boilerplate & maintenance
• some optimal characters don't render nicely
*/


prefix operator ¬
@inline(__always) public prefix func ¬(a: Bool) -> Bool {return !a}

infix operator ¬=: ComparisonPrecedence
@inline(__always) public func ¬=<A: Equatable>(a: A, b: A) -> Bool {return a != b}
@inline(__always) public func ¬=<A: Equatable>(a: A?, b: A?) -> Bool {return a != b}
@inline(__always) public func ¬=<A>(a: A?, b: _OptionalNilComparisonType) -> Bool {return a != b}
@inline(__always) public func ¬=<A>(a: _OptionalNilComparisonType, b: A?) -> Bool {return a != b}

infix operator ¬==: ComparisonPrecedence
@inline(__always) public func ¬==(a: AnyObject, b: AnyObject) -> Bool {return a !== b}
@inline(__always) public func ¬==(a: AnyObject?, b: AnyObject?) -> Bool {return a !== b}

@available(*, deprecated, renamed: "√")
@inline(__always) public func sqrt<A>(a: A) {fatalError()}

prefix operator √
@inline(__always) public prefix func √<A: FloatingPoint>(a: A) -> A {return Foundation.sqrt(a)}
@inline(__always) public prefix func √(a: Float) -> Float {return Foundation.sqrt(a)}
@inline(__always) public prefix func √(a: Double) -> Double {return Foundation.sqrt(a)}

infix operator ×=: AssignmentPrecedence
@inline(__always) public func ×=<A: FloatingPoint>(a: inout A, b: A) {return a *= b}
@inline(__always) public func ×=<A: IntegerArithmetic>(a: inout A, b: A) {return a *= b}

infix operator ÷=: AssignmentPrecedence
@inline(__always) public func ÷=<A: FloatingPoint>(a: inout A, b: A) {return a /= b}
@inline(__always) public func ÷=<A: IntegerArithmetic>(a: inout A, b: A) {return a /= b}


infix operator ≤: ComparisonPrecedence
@inline(__always) public func ≤<A: Comparable>(a: A, b: A) -> Bool {return a <= b}

infix operator ≥: ComparisonPrecedence
@inline(__always) public func ≥<A: Comparable>(a: A, b: A) -> Bool {return a >= b}

infix operator ×: MultiplicationPrecedence
@inline(__always) public func ×<A: FloatingPoint>(a: A, b: A) -> A {return a * b}
@inline(__always) public func ×<A: IntegerArithmetic>(a: A, b: A) -> A {return a * b}

infix operator ÷: MultiplicationPrecedence
@inline(__always) public func ÷<A: FloatingPoint>(a: A, b: A) -> A {return a / b}
@inline(__always) public func ÷<A: IntegerArithmetic>(a: A, b: A) -> A {return a / b}

precedencegroup SetComparisonPrecedence {
	higherThan: ComparisonPrecedence
	lowerThan: NilCoalescingPrecedence
}

precedencegroup SetOperationPrecedence {
	higherThan: MultiplicationPrecedence
	lowerThan: BitwiseShiftPrecedence
}

infix operator ∨: LogicalDisjunctionPrecedence
public func ∨(a: Bool, b: @autoclosure () -> Bool) -> Bool {return a || b()}

infix operator ∧: LogicalConjunctionPrecedence
public func ∧(a: Bool, b: @autoclosure () -> Bool) -> Bool {return a && b()}

infix operator ∈: SetComparisonPrecedence
public func ∈<A: SetAlgebra>(a: A.Element, b: A) -> Bool {return b.contains(a)}

infix operator ∉: SetComparisonPrecedence
public func ∉<A: SetAlgebra>(a: A.Element, b: A) -> Bool {return !(a ∈ b)}

infix operator ∋: SetComparisonPrecedence
public func ∋<A: SetAlgebra>(a: A, b: A.Element) -> Bool {return b ∈ a}

infix operator ∌: SetComparisonPrecedence
public func ∌<A: SetAlgebra>(a: A, b: A.Element) -> Bool {return !(b ∈ a)}

infix operator ⊂: SetComparisonPrecedence
public func ⊂<A: SetAlgebra>(a: A, b: A) -> Bool {return a.isStrictSubset(of: b)}

infix operator ⊃: SetComparisonPrecedence
public func ⊃<A: SetAlgebra>(a: A, b: A) -> Bool {return a.isStrictSubset(of: b)}

infix operator ⊆: SetComparisonPrecedence
public func ⊆<A: SetAlgebra>(a: A, b: A) -> Bool {return a.isSubset(of: b)}

infix operator ⊇: SetComparisonPrecedence
public func ⊇<A: SetAlgebra>(a: A, b: A) -> Bool {return a.isSuperset(of: b)}

infix operator ≡: ComparisonPrecedence
public func ≡(a: AnyObject, b: AnyObject) -> Bool {return a === b}
public func ≡(a: AnyObject?, b: AnyObject?) -> Bool {return a === b}

infix operator ¬≡: ComparisonPrecedence
public func ¬≡(a: AnyObject, b: AnyObject) -> Bool {return a !== b}
public func ¬≡(a: AnyObject?, b: AnyObject?) -> Bool {return a !== b}

infix operator ∪: SetOperationPrecedence
public func ∪<A: SetAlgebra>(a: A, b: A) -> A {return a.union(b)}

infix operator ∩: SetOperationPrecedence
public func ∩<A: SetAlgebra>(a: A, b: A) -> A {return a.intersection(b)}

