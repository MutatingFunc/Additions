//
//  Observable.swift
//  Additions
//
//  Created by James Froggatt on 06.03.2017.
//
//

import Foundation

//Observable

public final class Observable<Value> {
	public typealias Stream = Additions.Stream<Value>
	
	public let stream: Stream
	fileprivate var subscription: EventSubscription!
	
	public fileprivate(set) var latest: Value
	
	public init(_ stream: Stream, initial: Value) {
		self.latest = initial
		self.stream = stream
		self.subscription = stream.subscribe {[weak self] in
			self?.latest = $0
		}
	}
	public static func make(initial: Value) -> (observable: Observable<Value>, event: Event<Value>) {
		let event = Event<Value>()
		let observable = Observable(event.stream, initial: initial)
		return (observable, event)
	}
	
	public func subscribeNow(_ handler: @escaping (Value) -> ()) -> EventSubscription {
		handler(self.latest)
		return stream.subscribe(handler)
	}
	public func subscribeNow(_ event: Event<Value>) -> EventSubscription {
		return stream.subscribe(event)
	}
	public func subscribeNow(_ nsObject: NSObject, _ handler: @escaping (Value) -> ()) {
		handler(self.latest)
		return stream.subscribe(nsObject, handler)
	}
}

public extension Stream {
	func observable(initial: Notification) -> Observable<Notification> {
		return Observable(self, initial: initial)
	}
}
