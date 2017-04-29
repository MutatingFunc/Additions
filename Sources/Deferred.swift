//
//  Deferred.swift
//  Additions
//
//  Created by James Froggatt on 17.04.2017.
//
//

public class DeferredCreatable<Source> {
	fileprivate init() {}
	public func create(with source: Source) {fatalError()}
}

public class Deferred<Source, Result>: DeferredCreatable<Source> {
	fileprivate let constructor: (Source) -> Result
	
	public init(_ constructor: @escaping (Source) -> Result) {
		self.constructor = constructor
	}
	public init<A, B>(currying constructor: @escaping (Source, A) -> B)
			where Result == Deferred<A, B> {
		self.constructor = {source in
			Deferred<A, B>{constructor(source, $0)}
		}
	}
	
	override public func create(with source: Source) {
		precondition(result == nil)
		result = constructor(source)
	}
	
	public fileprivate(set) var result: Result?
}
