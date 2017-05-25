//
//  Reference.swift
//  Additions
//
//  Created by James Froggatt on 24.10.2016.
//
//

/*
inactive - too general, create specific types for these tasks
*/

public final class Reference<Target> {
	public var target: Target {
		didSet {changeEvent.notify(target)}
	}
	public init(_ target: Target) {
		self.target = target
	}
	private let changeEvent = Event<Target>()
	public var changed: EventStream<Target> {return changeEvent.stream}
}
