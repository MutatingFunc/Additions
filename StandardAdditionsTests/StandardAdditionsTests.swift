//
//  StandardAdditionsTests.swift
//  StandardAdditionsTests
//
//  Created by James Froggatt on 26.03.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

import XCTest
@testable import Additions

class StandardAdditionsTests: XCTestCase {
	
	func testSplat() {
		func add(a: Int, b: Int) -> Int {
			return a + b
		}
		let params = (1, 2)
		//expect no compile errors
		let result1 = splat(add)(params)
		let result2 = params => add
		//
		XCTAssert(result1 == 3 && result2 == 3)
	}
	
	func testPerformanceExample() {
		self.measure {}
	}
    
}
