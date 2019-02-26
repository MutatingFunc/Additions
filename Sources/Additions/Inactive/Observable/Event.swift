//
//  Event.swift
//  Additions
//
//  Created by James Froggatt on 22.09.2016.
//
//

import Foundation

private class HandlerRef<Notification> {
	let handle: (Notification) -> ()
	
	init(_ handle: @escaping (Notification) -> ()) {
		self.handle = handle
	}
}

public final class Event<Notification> {
	public let stream: Stream<Notification>
	private let hashTable: NSHashTable<HandlerRef<Notification>> = .weakObjects()
	
	public init() {
		self.stream = Stream {[weak hashTable] handler in
			let ref = HandlerRef(handler)
			hashTable?.add(ref)
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

public extension Event where Notification == () {
	public func notify() {
		notify(())
	}
}
