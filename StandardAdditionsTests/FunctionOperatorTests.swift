//
//  FunctionOperatorTests.swift
//  StandardAdditions
//
//  Created by James Froggatt on 30.05.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

import XCTest
@testable import Additions

class FunctionOperatorTests: XCTestCase {

	let add2: (Int) -> (Int) = {$0 + 2}
	let add5: (Int) -> (Int) = {$0 + 5}
	
	func testMap() {
		{
			var a = 5
			a = a => add2
			XCTAssert(a == 7)
			
			a = 5
			a = a => add5 => add2
			XCTAssert(a == 12)
		}();
		{
			var a: Int? = 5
			a = a ?=> add2
			XCTAssert(a == 7)
			
			a = 5
			a = a ?=> add5 ?=> add2
			XCTAssert(a == 12)
		}();
	}
	
	func testApply() {
		{
			var a = 5
			a = a +> {$0 + 2}
			XCTAssert(a == 5)
			
			a = 5
			a = a +> add5 +> add2
			XCTAssert(a == 5)
		}();
		{
			var a: Int? = 5
			a = a ?+> add2
			XCTAssert(a == 5)
			
			a = 5
			a = a ?+> add5 ?+> add2
			XCTAssert(a == 5)
		}();
	}

	func testPerformanceExample() {
			measure {}
	}

}

