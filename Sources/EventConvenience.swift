//
//  EventConvenience.swift
//  Additions
//
//  Created by James Froggatt on 06.03.2017.
//
//

import Foundation

public extension Stream {
	func map<Result>(_ transform: @escaping (Notification) -> Result) -> Stream<Result> {
		return self.flatMap(transform)
	}
	func filter(_ include: @escaping (Notification) -> Bool) -> Stream<Notification> {
		return self.flatMap{include($0) ? $0 : nil}
	}
	
	func subscribe(_ event: Event<Notification>) -> EventSubscription {
		return self.subscribe {[weak event] in
			event?.notify($0)
		}
	}
	func subscribe(_ nsObject: NSObject, _ handler: @escaping (Notification) -> ()) {
		nsObject.subscriptions.insert(self.subscribe(handler))
	}
}

private var key: ()? = ()
public extension NSObject {
	var subscriptions: Set<EventSubscription> {
		get {
			let test = objc_getAssociatedObject(self, &key) as? NSSet
			return test?.allObjects.map{$0 as! EventSubscription} ?=> Set.init ?? []
		}
		set {objc_setAssociatedObject(self, &key, newValue as NSSet, .OBJC_ASSOCIATION_RETAIN)}
	}
}
public func +=(lhs: inout Set<EventSubscription>, rhs: EventSubscription) {
	lhs.insert(rhs)
}
public func +=(lhs: inout Set<EventSubscription>, rhs: Set<EventSubscription>) {
	lhs.formUnion(rhs)
}
public func -=(lhs: inout Set<EventSubscription>, rhs: EventSubscription) {
	lhs.remove(rhs)
}
public func -=(lhs: inout Set<EventSubscription>, rhs: Set<EventSubscription>) {
	lhs.subtract(rhs)
}
