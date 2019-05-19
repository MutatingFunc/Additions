//
//  Extensions.swift
//  Additions
//
//  Created by James Froggatt on 19.05.2019.
//

#if canImport(XCTest)
import XCTest

/// To avoid need for XCTest import in actual tests
public typealias Test = XCTestCase

@available(iOSApplicationExtension 9.0, *)
public extension XCTestCase {
	@discardableResult
	func withActivity<Result>(_ name: String, _ action: (XCTActivity) -> Result) -> Result {
		return XCTContext.runActivity(named: name, block: action)
	}
}

public extension NSPredicate {
	convenience init<Type>(for type: Type.Type, _ predicate: @escaping (Type) -> Bool) {
		self.init {object, _ in
			predicate(object as! Type)
		}
	}
}
public extension XCTNSPredicateExpectation {
	convenience init<Type>(suchThat object: Type, fulfils predicate: @escaping (Type) -> Bool) {
		self.init(predicate: NSPredicate(for: Type.self, predicate), object: object)
	}
}

@available(iOSApplicationExtension 9.0, *)
public extension XCUIElementQuery {
	func matching(_ predicate: @escaping (XCUIElementAttributes) -> Bool) -> XCUIElementQuery {
		return self.matching(NSPredicate(for: XCUIElementAttributes.self, predicate))
	}
	func element(matching predicate: @escaping (XCUIElementAttributes) -> Bool) -> XCUIElement {
		return self.element(matching: NSPredicate(for: XCUIElementAttributes.self, predicate))
	}
	func wait(for predicate: @escaping (XCUIElementQuery) -> Bool, timeout: TimeInterval = 8, _ result: XCTWaiter.Result = .completed) {
		let expectation = XCTNSPredicateExpectation(
			predicate: NSPredicate(for: XCUIElementQuery.self, predicate),
			object: self
		)
		XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: timeout), result)
	}
}

@available(iOSApplicationExtension 9.0, *)
public extension XCUIElement {
	func wait(for predicate: @escaping (XCUIElement) -> Bool, timeout: TimeInterval = 8, _ result: XCTWaiter.Result = .completed) {
		let expectation = XCTNSPredicateExpectation(suchThat: self, fulfils: predicate)
		XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: timeout), result)
	}
}
#endif
