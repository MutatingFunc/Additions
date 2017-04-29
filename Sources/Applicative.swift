//
//  Applicative.swift
//  Additions
//
//  Created by James Froggatt on 05.09.2016.
//
//

precedencegroup ApplicativePrecedence {
	associativity: left
	higherThan: NilCoalescingPrecedence, DefaultPrecedence
}

///map
infix operator => : ApplicativePrecedence
public func =><In, Out>(a: In, b: (In) throws -> Out) rethrows -> Out {
	return try b(a)
}

infix operator ?=> : ApplicativePrecedence
public func ?=><In, Out>(a: In?, b: (In) throws -> Out?) rethrows -> Out? {
	return try a.flatMap(b)
}

///applying
infix operator +> : ApplicativePrecedence
public func +><In, Out>(a: In, b: (In) throws -> Out) rethrows -> In {
	_ = try b(a); return a
}

infix operator ?+> : ApplicativePrecedence
public func ?+><In, Out>(a: In?, b: (In) throws -> Out?) rethrows -> In? {
	_ = try a.flatMap(b); return a
}
