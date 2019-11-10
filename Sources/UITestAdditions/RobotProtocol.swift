//
//  RobotProtocol.swift
//  Additions
//
//  Created by James Froggatt on 19.05.2019.
//

#if !os(watchOS) && canImport(XCTest)
import XCTest

import Additions

public protocol Robot {
	init()
	static var appBundleID: String? {get}
}

public extension Robot {
	static var appBundleID: String? {nil}
	var app: XCUIApplication {Self.appBundleID =>? XCUIApplication.init ?? XCUIApplication()}
	
	
	func action<Result>(_ name: String = #function, _ action: () -> Result) -> Result {
		XCTContext.runActivity(named: name, block: {_ in action()})
	}
	
	@discardableResult
	func takeScreenshot(_ activity: XCTActivity) -> Self {
		sleep(1)
		let screenshot = XCUIScreen.main.screenshot()
		let screenshotAttachment = XCTAttachment(screenshot: screenshot)
			+> {$0.lifetime = .keepAlways}
		activity.add(screenshotAttachment)
		return self
	}
	
	#if canImport(UIKit) && os(iOS)
	func rotate(to orientation: UIDeviceOrientation) -> Self {
		XCUIDevice.shared.orientation = orientation
		return self
	}
	#endif
	
	@available(*, renamed: "showHomescreen")
	func returnToHome() -> HomeScreenRobot {showHomeScreen()}
	
	func showHomeScreen() -> HomeScreenRobot {.init()}
	
	func launchSettings() -> SettingsRobot {.init()}
}

#if !os(tvOS)
public protocol PoppableRobot: Robot {
	associatedtype Parent: Robot
}
public extension PoppableRobot {
	func pop() -> Parent {
		action {
			app.navigationBars.firstMatch.buttons.firstMatch.tap()
			return .init()
		}
	}
}
#endif
#endif
