//
//  Observable.swift
//  Additions
//
//  Created by James Froggatt on 06.03.2017.
//
//

//Observable

public protocol Observable {
	associatedtype Value
	var stream: Stream<Value> {get}
	var latest: Value {get}
}

// ReadOnlyObservable

public final class ReadOnlyObservable<Value>: Observable {
	public let stream: Stream<Value>
	private var subscription: EventSubscription!
	
	public private(set) var latest: Value
	
	public init(_ stream: Stream<Value>, initial: Value) {
		self.latest = initial
		self.stream = stream
		self.subscription = stream.subscribe {[weak self] in
			self?.latest = $0
		}
	}
	
	private convenience init<Source>(flatMapping stream: Stream<Source>, through transform: @escaping (Source) -> Value?, initial: Value) {
		self.init(stream.flatMap(transform), initial: initial)
	}
}
public extension ReadOnlyObservable {
	func flatMap<Result>(_ transform: @escaping (Value) -> Result?, initial: Result) -> ReadOnlyObservable<Result> {
		return .init(flatMapping: stream, through: transform, initial: initial)
	}
	func map<Result>(_ transform: @escaping (Value) -> Result) -> ReadOnlyObservable<Result> {
		return .init(stream.map(transform), initial: transform(latest))
	}
	func filter(_ include: @escaping (Value) -> Bool) -> ReadOnlyObservable {
		return ReadOnlyObservable(stream.filter(include), initial: latest)
	}
}

// WritableObservable

public final class WritableObservable<Value>: Observable {
	public let getter: ReadOnlyObservable<Value>
	public let setter: Event<Value>
	
	public var stream: Stream<Value> {return getter.stream}
	public var latest: Value {
		get {return getter.latest}
		set {setter.notify(newValue)}
	}
	
	
	private init(getter: ReadOnlyObservable<Value>, setter: Event<Value>) {
		self.getter = getter
		self.setter = setter
	}
	private convenience init(_ stream: Stream<Value>, initial: Value, setter: Event<Value>) {
		self.init(getter: ReadOnlyObservable(stream, initial: initial), setter: setter)
	}
	public convenience init(initial: Value) {
		let event = Event<Value>()
		self.init(event.stream, initial: initial, setter: event)
	}
}
public extension WritableObservable {
	func map<Result>(_ transformGetter: @escaping (Value) -> Result, reverseMap transformSetter: @escaping (Result) -> Value) -> (observable: WritableObservable<Result>, subscription: EventSubscription) {
		let setter = Event<Result>()
		return (
			.init(getter: getter.map(transformGetter), setter: setter),
			setter.stream.map(transformSetter).subscribe(self.setter)
		)
	}
	func map<Result>(_ transformGetter: @escaping (Value) -> Result, updateOriginal: @escaping (inout Value, Result) -> ()) -> (observable: WritableObservable<Result>, subscription: EventSubscription) {
		return self.map(
			transformGetter,
			reverseMap: {[getter] newValue in
				var oldValue = getter.latest
				updateOriginal(&oldValue, newValue)
				return oldValue
			}
		)
	}
}

public extension Observable {
	public func subscribeNow(_ handler: @escaping (Value) -> ()) -> EventSubscription {
		handler(self.latest)
		return stream.subscribe(handler)
	}
	public func subscribeNow(_ event: Event<Value>) -> EventSubscription {
		return stream.subscribe(event)
	}
}
