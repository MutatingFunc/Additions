//
//  EventConvenience.swift
//  Additions
//
//  Created by James Froggatt on 06.03.2017.
//
//

import Foundation

public extension Event where Notification == () {
	public func notify() {
		notify(())
	}
}
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
}

extension EventSubscription: Hashable {}
