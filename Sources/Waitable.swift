//
//  Waitable.swift
//  Additions
//
//  Created by James Froggatt on 27.09.2016.
//
//

import Foundation

///wraps a function which waits for a process to complete
public struct Waitable<Result> {
	///waits for the process to complete
	public let wait: () -> Result
	fileprivate init(_ process: @escaping () -> Result) {self.wait = process}
}
///begins calculating the result of a function asynchronously
public func async<Out>(priority: DispatchQoS.QoSClass = .default, _ f: @escaping () -> Out) -> Waitable<Out> {
	let semaphore = DispatchSemaphore(value: 0)
	var result: Out? = nil
	DispatchQueue.global(qos: priority).async {
		result = f()
		semaphore.signal()
	}
	return Waitable {
		semaphore.wait()
		return result!
	}
}
///runs a function in a background thread, and calls the callback with the result
public func await<Out>(
	_ f: @escaping () -> Out, priority: DispatchQoS.QoSClass = .default,
	returnQueue: DispatchQueue = .main, resultHandler: @escaping (Out) -> ()
	) {
	DispatchQueue.global(qos: priority).async {
		let result = f()
		returnQueue.async {
			resultHandler(result)
		}
	}
}
