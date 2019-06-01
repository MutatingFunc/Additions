//
//  AdditionsTests.swift
//  AdditionsTests
//
//  Created by James Froggatt on 20.02.2017.
//
//

import XCTest
@testable import Additions

class AdditionsTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testObjCAssociatedObjects() {
		let object = NSObject()
		XCTAssertNil(object[associatedObject: ""])
		
		object[associatedObject: ""] = 1
		XCTAssertNotNil(object[associatedObject: ""])
		XCTAssertNil(object[associatedObject: "a"])
		
		object[associatedObject: ""] = nil
		XCTAssertNil(object[associatedObject: ""])
		
		object[associatedObject: "a"] = 1
		XCTAssertNil(object[associatedObject: ""])
		XCTAssertNotNil(object[associatedObject: "a"])
		
		object[associatedObject: "aye"] = 1
		XCTAssertNotNil(object[associatedObject: "aye"])
		XCTAssertNotNil(object[associatedObject: "a"])
	}
	
	func testOptionalSequence() {
		let sequence = Optional([1])
		XCTAssertNotNil(sequence.makeIterator())
		for i in sequence {
			XCTAssertEqual(i, 1)
		}
		//Disabled due to compiler bugs
		//XCTAssertFalse(i.isEmpty)
	}
	
	static let allTests = [
		("testObjCAssociatedObjects", testObjCAssociatedObjects),
		("testOptionalSequence", testOptionalSequence),
	]
}
