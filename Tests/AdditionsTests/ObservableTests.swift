//
//  ObservableTests.swift
//  Additions
//
//  Created by James Froggatt on 31.05.2019.
//
//

import XCTest
@testable import Additions

var t = 0
class ObservableTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	class Recipient: NSObject {
		var i: Int
		init(_ i: Int) {self.i = i}
	}
	
	func testEventCapture() {
		let event = Event<Int>()
		let capturedRecipient = Recipient(0)
		let s1 = event.stream.subscribe {
			capturedRecipient.i = $0
		}
		event.notify(1)
		XCTAssert(capturedRecipient.i == 1)
		s1.end()
		event.notify(2)
		XCTAssert(capturedRecipient.i == 1)
	}
	/*func testEventNSObject() {
	let event = Event<Int>()
	let objectRecipient = Recipient(0)
	event.stream.subscribe(objectRecipient) {[weak objectRecipient] in
	objectRecipient?.i = $0
	}
	XCTAssert(objectRecipient.subscriptions.count == 1)
	defer {_ = objectRecipient}
	event.notify(1)
	XCTAssert(objectRecipient.i == 1)
	}*/
	func testObservable() {
		let observable = WritableObservable(initial: 0)
		XCTAssert(observable.latest == 0)
		observable.latest = 1
		XCTAssert(observable.latest == 1)
	}
	
	func testSync() {
		let event = Event<()>()
		
		var async = true
		let s1 = event.stream.subscribe {
			async = false
		}
		withExtendedLifetime(s1, event.notify)
		XCTAssert(async == false)
	}
	func testAsync() {
		let queue = DispatchQueue(label: "TestQueue")
		let sem = DispatchSemaphore(value: 0)
		let completion = expectation(description: "handler called")
		
		let event = Event<()>()
		let asyncStream = event.stream.async(queue)
		
		var async = true
		let s2 = asyncStream.subscribe {_ in
			sem.wait()
			completion.fulfill()
			async = false
		}
		withExtendedLifetime(s2, event.notify)
		XCTAssert(async == true)
		sem.signal()
		waitForExpectations(timeout: 5)
	}
	
	func testMap() {
		let event = Event<()>()
		
		var calls1 = 0
		let s1 = event.stream.subscribe {
			calls1 += 1
		}
		withExtendedLifetime(s1, event.notify)
		XCTAssertEqual(calls1, 1)
		var calls2 = 0
		let s2 = event.stream.map{}.subscribe {
			calls2 += 1
		}
		withExtendedLifetime((s1, s2), event.notify)
		XCTAssertEqual(calls1, 2)
		XCTAssertEqual(calls2, 1)
	}
	
	static let allTests = [
		("testEventCapture", testEventCapture),
		//("testEventNSObject", testEventNSObject),
		("testObservable", testObservable),
		("testSync", testSync),
		("testAsync", testAsync),
	]
}
