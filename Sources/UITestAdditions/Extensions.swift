//
//  Extensions.swift
//  Additions
//
//  Created by James Froggatt on 19.05.2019.
//

#if !os(watchOS) && canImport(XCTest)
import XCTest

/// To avoid need for XCTest import in actual tests
public typealias Test = XCTestCase

public extension XCTestCase {
	@discardableResult
	func withActivity<Result>(_ name: String, _ action: (XCTActivity) -> Result) -> Result {
		XCTContext.runActivity(named: name, block: action)
	}
}

public extension XCTNSPredicateExpectation {
	convenience init<Type>(suchThat object: Type, fulfils predicate: @escaping (Type) -> Bool) {
		self.init(predicate: NSPredicate(for: Type.self, predicate), object: object)
	}
}

public extension XCUIElementQuery {
	func matching(_ predicate: @escaping (XCUIElementAttributes) -> Bool) -> XCUIElementQuery {
		self.matching(NSPredicate(for: XCUIElementAttributes.self, predicate))
	}
	func element(matching predicate: @escaping (XCUIElementAttributes) -> Bool) -> XCUIElement {
		self.element(matching: NSPredicate(for: XCUIElementAttributes.self, predicate))
	}
	func wait(for predicate: @escaping (XCUIElementQuery) -> Bool, timeout: TimeInterval = 8, _ result: XCTWaiter.Result = .completed) {
		let expectation = XCTNSPredicateExpectation(
			predicate: NSPredicate(for: XCUIElementQuery.self, predicate),
			object: self
		)
		XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: timeout), result)
	}
	
	#if swift(<999)
	//https://apple.github.io/swift-evolution/#?search=Key%20Path%20Expressions%20as%20Functions
	func matching(_ predicate: KeyPath<XCUIElementAttributes, Bool>) -> XCUIElementQuery {
		matching({$0[keyPath: predicate]})
	}
	func element(matching predicate: KeyPath<XCUIElementAttributes, Bool>) -> XCUIElement {
		element(matching: {$0[keyPath: predicate]})
	}
	func wait(for predicate: KeyPath<XCUIElementQuery, Bool>, timeout: TimeInterval = 8, _ result: XCTWaiter.Result = .completed) {
		wait(for: {$0[keyPath: predicate]}, timeout: timeout, result)
	}
	#endif
}

public extension XCUIElement {
	func wait(for predicate: @escaping (XCUIElement) -> Bool, timeout: TimeInterval = 8, _ result: XCTWaiter.Result = .completed) {
		let expectation = XCTNSPredicateExpectation(suchThat: self, fulfils: predicate)
		XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: timeout), result)
	}
	#if swift(<999)
	//https://apple.github.io/swift-evolution/#?search=Key%20Path%20Expressions%20as%20Functions
	func wait(for predicate: KeyPath<XCUIElement, Bool>, timeout: TimeInterval = 8, _ result: XCTWaiter.Result = .completed) {
		wait(for: {$0[keyPath: predicate]}, timeout: timeout, result)
	}
	#endif
}
#endif
