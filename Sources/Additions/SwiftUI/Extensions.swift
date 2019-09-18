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
			.receive(on: DispatchQueue.main)
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
