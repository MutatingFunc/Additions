//
//  ScrollingExtensions.swift
//  
//
//  Created by James Froggatt on 10/11/2019.
//

#if os(iOS) && canImport(XCTest)
import XCTest

public enum SwipeDirection {
	case up
	case down
	case left
	case right
}

public extension XCUIElement {
	#if !TARGET_OS_MACCATALYST
	func swipe(_ direction: SwipeDirection) {
		switch direction {
		case .up: swipeUp()
		case .down: swipeDown()
		case .left: swipeLeft()
		case .right: swipeRight()
		}
	}
	#endif
}

public extension XCUIElement {
	@discardableResult
	func scrollTo(
		in scrollView: XCUIElement,
		direction: SwipeDirection = .up,
		swipeLimit: Int = 5,
		until shouldStop: KeyPath<XCUIElement, Bool> = \.exists
	) -> Bool {
		scrollTo(in: scrollView, direction: direction, swipeLimit: swipeLimit, until: {self[keyPath: shouldStop]})
	}
	@discardableResult
	func scrollTo(
		in scrollView: XCUIElement,
		direction: SwipeDirection = .up,
		swipeLimit: Int = 5,
		until shouldStop: () -> Bool
	) -> Bool {
		var swipesRemaining = swipeLimit
		while !shouldStop() && swipesRemaining > 0 {
			scrollView.swipe(direction)
			swipesRemaining -= 1
		}
		return shouldStop()
	}
}
#endif
