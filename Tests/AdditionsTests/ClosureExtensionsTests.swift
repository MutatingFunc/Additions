//
//  ClosureExtensionsTests.swift
//  Additions
//
//  Created by James Froggatt on 01.06.2019.
//

#if canImport(UIKit)
import UIKit
#endif
import XCTest
@testable import Additions

class ClosureExtensionsTests: XCTestCase {
	#if canImport(UIKit)
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testButtonHandler() {
		let button = UIButton()
		
		button.addHandler(for: .touchUpInside) {_ in}
		XCTAssertEqual(button.actions(forTarget: button[associatedObject: UIHandler.id(for: .touchUpInside)], forControlEvent: .touchUpInside), [#selector(UIHandler.handle).description])
		
		button.addHandler(for: .touchDown) {_ in}
		XCTAssertEqual(button.actions(forTarget: button[associatedObject: UIHandler.id(for: .touchDown)], forControlEvent: .touchDown), [#selector(UIHandler.handle).description])
		XCTAssertEqual(button.actions(forTarget: button[associatedObject: UIHandler.id(for: .touchUpInside)], forControlEvent: .touchUpInside), [#selector(UIHandler.handle).description])
		
		button.removeHandler(for: .touchUpInside)
		XCTAssertEqual(button.actions(forTarget: button[associatedObject: UIHandler.id(for: .touchUpInside)], forControlEvent: .touchUpInside), nil)
		XCTAssertEqual(button.actions(forTarget: button[associatedObject: UIHandler.id(for: .touchDown)], forControlEvent: .touchDown), [#selector(UIHandler.handle).description])
	}
	
	func testBarButtonItemHandler() {
		let button = UIBarButtonItem(barButtonSystemItem: .add) {_ in}
		XCTAssertEqual(button.target as? UIHandler, button[associatedObject: UIHandler.defaultID] as? UIHandler)
		XCTAssertEqual(button.action, #selector(UIHandler.handle))
		
		button.removeHandler()
		XCTAssertEqual(button.target as? UIHandler, nil)
		XCTAssertEqual(button.action, nil)
		
		button.setHandler{_ in}
		XCTAssertEqual(button.target as? UIHandler, button[associatedObject: UIHandler.defaultID] as? UIHandler)
		XCTAssertEqual(button.action, #selector(UIHandler.handle))
		
		button.setHandler{_ in}
		XCTAssertEqual(button.target as? UIHandler, button[associatedObject: UIHandler.defaultID] as? UIHandler)
		XCTAssertEqual(button.action, #selector(UIHandler.handle))
	}
	
	//Can't test, no targets accessible
	/*
	func testGestureRecognizerHandler() {
	}
	*/
	
	static let allTests = [
		("testButtonHandler", testButtonHandler),
		("testBarButtonItemHandler", testBarButtonItemHandler),
	]
	#endif
}
