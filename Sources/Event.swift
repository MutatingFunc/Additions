//
//  Event.swift
//  Additions
//
//  Created by James Froggatt on 22.09.2016.
//
//

import Foundation

//Event

public final class Event<Notification> {
	public typealias Stream = Additions.Stream<Notification>
	
	public let stream: Stream
	private let hashTable: NSHashTable<HandlerRef<Notification>> = .weakObjects()
	
	public init() {
		let hashTable = self.hashTable
		self.stream = Stream {handler in
			let ref = HandlerRef(handler)
			hashTable.add(ref)
			return EventSubscription {[weak hashTable] in
				hashTable?.remove(ref)
			}
		}
	}
	
	public func notify(_ notification: Notification) {
		for handler in hashTable.allObjects {
			handler.handle(notification)
		}
	}
}

private class HandlerRef<Notification> {
	let handle: (Notification) -> ()
	
	init(_ handle: @escaping (Notification) -> ()) {
		self.handle = handle
	}
}

//Stream

public struct Stream<Notification> {
	public typealias Subscribe = (_ handler: @escaping (Notification) -> ()) -> EventSubscription
	private let subscribeSource: Subscribe
	
	fileprivate init(_ subscribe: @escaping Subscribe) {
		self.subscribeSource = subscribe
	}
	private init(_ queue: DispatchQueue, _ subscribe: @escaping Subscribe) {
		self.init {handler in
			subscribe {notification in
				queue.async {
					handler(notification)
				}
			}
		}
	}
	private init<Source>(flatMapping subscribe: @escaping (_ handler: @escaping (Source) -> ()) -> EventSubscription, through transform: @escaping (Source) -> Notification?) {
		self.init {handler in
			subscribe {
				transform($0).map(handler)
			}
		}
	}
	
	public func flatMap<Result>(_ transform: @escaping (Notification) -> Result?) -> Stream<Result> {
		return .init(flatMapping: self.subscribeSource, through: transform)
	}
	public func async(_ queue: DispatchQueue = .global()) -> Stream {
		return .init(queue, self.subscribeSource)
	}
	
	public func subscribe(_ handler: @escaping (Notification) -> ()) -> EventSubscription {
		return subscribeSource(handler)
	}
}

//Subscription

public final class EventSubscription {
	private var unsub: (() -> ())?
	public var isActive: Bool {return unsub ¬= nil}
	
	fileprivate init(_ unsub: @escaping () -> ()) {
		self.unsub = unsub
	}
	deinit {end()}
	
	public func end() {
		unsub?()
		unsub = nil
	}
}

