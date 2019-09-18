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
	static var appBundleID: String? {return nil}
	var app: XCUIApplication {return Self.appBundleID =>? XCUIApplication.init ?? XCUIApplication()}
	
	
	func action<Result>(_ name: String = #function, _ action: () -> Result) -> Result {
		return XCTContext.runActivity(named: name, block: {_ in action()})
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
	
	@available(*, renamed: "returnToHome", message: "Devices may not have a home button")
	func pressHome() -> HomeScreenRobot {return returnToHome()}
	
	func returnToHome() -> HomeScreenRobot {
		return HomeScreenRobot()
	}
	
	func launchSettings() -> SettingsRobot {
		return SettingsRobot()
	}
}

#if !os(tvOS)
public protocol PoppableRobot: Robot {
	associatedtype Parent: Robot
}
public extension PoppableRobot {
	func pop() -> Parent {return action {
		app.navigationBars.firstMatch.buttons.firstMatch.tap()
		return Parent()
	}}
}
#endif
#endif
