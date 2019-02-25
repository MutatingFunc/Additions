//
//  Stream.swift
//  Additions
//
//  Created by James Froggatt on 25.02.2019.
//

import Foundation

public struct Stream<Notification> {
	public typealias Subscribe = (_ handler: @escaping (Notification) -> ()) -> EventSubscription
	private let subscribeSource: Subscribe
	
	init(_ subscribe: @escaping Subscribe) {
		self.subscribeSource = subscribe
	}
	private init(async queue: DispatchQueue, _ subscribe: @escaping Subscribe) {
		self.init {handler in
			subscribe {notification in
				queue.async {
					handler(notification)
				}
			}
		}
	}
	
	public func async(_ queue: DispatchQueue = .global()) -> Stream {
		return Stream(async: queue, self.subscribeSource)
	}
	
	public func subscribe(_ handler: @escaping (Notification) -> ()) -> EventSubscription {
		return subscribeSource(handler)
	}
}

public extension Stream {
	public func flatMap<Result>(_ transform: @escaping (Notification) -> Result?) -> Stream<Result> {
		return Stream<Result> {[subscribeSource] handler in
			subscribeSource {
				_ = transform($0).map(handler)
			}
		}
	}
	func map<Result>(_ transform: @escaping (Notification) -> Result) -> Stream<Result> {
		return self.flatMap(transform)
	}
	func filter(_ include: @escaping (Notification) -> Bool) -> Stream {
		return self.flatMap{include($0) ? $0 : nil}
	}
}

public extension Stream {
	func subscribe(_ event: Event<Notification>) -> EventSubscription {
		return self.subscribe(event.notify)
	}
	
	func observable(initial: Notification) -> ReadOnlyObservable<Notification> {
		return .init(self, initial: initial)
	}
}
