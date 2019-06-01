//
//  Subscription.swift
//  Additions
//
//  Created by James Froggatt on 25.02.2019.
//

import Foundation

public final class EventSubscription: Hashable {
	private var unsub: (() -> ())?
	public var isActive: Bool {return unsub != nil}
	
	init(_ unsub: @escaping () -> ()) {
		self.unsub = unsub
	}
	deinit {end()}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(self))
	}
	
	public func end() {
		unsub?()
		unsub = nil
	}
}
