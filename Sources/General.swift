//
//  General.swift
//  Additions
//
//  Created by James Froggatt on 08.06.2017.
//

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
