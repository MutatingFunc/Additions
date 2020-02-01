//
//  Extensions.swift
//  
//
//  Created by James Froggatt on 18/09/2019.
//

#if canImport(Combine) && canImport(SwiftUI)
import Combine
import SwiftUI

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol _OptionalProtocol {
	associatedtype WrappedValue
	var _wrappedValue: WrappedValue? {get set}
}
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Optional: _OptionalProtocol {
	public var _wrappedValue: Self {
		get {self}
		set {self = newValue}
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Binding where Value: _OptionalProtocol {
	var ifCurrentlyNonNil: Binding<Value.WrappedValue>? {
		self.wrappedValue._wrappedValue != nil
			? .init(
				get: {self.wrappedValue._wrappedValue!},
				set: {self.wrappedValue._wrappedValue = $0}
			)
			: nil
	}
	var forceUnwrapping: Binding<Value.WrappedValue> {
		.init(
			get: {self.wrappedValue._wrappedValue!},
			set: {self.wrappedValue._wrappedValue = $0}
		)
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Sequence {
	func numbered<Range>(by n: Range) -> [Enumerated<Element>]
		where Range: Sequence, Range.Element == Int {
		zip(n, self).map(Enumerated.init)
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@dynamicMemberLookup
public struct Enumerated<Element> {
	public var number: Int
	public var element: Element
	
	public subscript<T>(dynamicMember keyPath: WritableKeyPath<Element, T>) -> T {
    get { element[keyPath: keyPath] }
    set { element[keyPath: keyPath] = newValue }
  }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Enumerated: Identifiable where Element: Identifiable {
	public var id: Element.ID {element.id}
}


@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public typealias ResultPublisher<ContentType> = AnyPublisher<Result<ContentType, Error>, Never>

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
	var asAny: AnyPublisher<Output, Failure> {AnyPublisher(self)}
	
	var asResult: Publishers.Catch<Publishers.Map<Self, Result<Self.Output, Error>>, Just<Result<Self.Output, Error>>> {
		self
			.map{Result<Output, Error>.success($0)}
			.catch{Just<Result<Output, Error>>(.failure($0))}
	}
	
	var asResultForUI: ResultPublisher<Output> {
		self
			.asResult
			.receive(on: RunLoop.main)
			.asAny
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
	var asAny: AnyView {AnyView(self)}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Cancellable {
	var asAny: AnyCancellable {AnyCancellable(self)}
}
#endif
