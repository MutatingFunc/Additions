//
//  Robots.swift
//  Additions
//
//  Created by James Froggatt on 19.05.2019.
//

#if canImport(XCTest)
import XCTest

public struct HomeScreenRobot: Robot {
	public init() {
		#if canImport(UIKit) && !os(watchOS)
		XCUIDevice.shared.press(.home)
		#endif
	}
}

public struct SettingsRobot: Robot {
	public static var appBundleID: String? {return "com.apple.Preferences"}
	
	public init() {
		app.launch()
		XCTAssert(app.wait(for: .runningForeground, timeout: 3))
	}
	
	#if os(iOS)
	@discardableResult
	public func setDefaultKeyboard() -> SettingsRobot {
		return action {
			if app.staticTexts["General"].exists {
				app.staticTexts["General"].tap()
				app.staticTexts["Keyboard"].tap()
				app.staticTexts["Keyboards"].tap()
			}
			let ckeyCell = app.cells["com.James.CustomKeyboard.Custom-Keyboard-Extension"]
			if ckeyCell.exists == false {
				app.staticTexts["Add New Keyboard..."].tap()
				let addCell = app.staticTexts.matching(identifier: "ℂKey²") //Multiple matches when view is modal
				addCell.allElementsBoundByIndex.forEach {
					if $0.isHittable {
						$0.tap()
					}
				}
			}
			app.navigationBars.buttons["Edit"].tap()
			ckeyCell.buttons["Reorder ℂKey²"].press(forDuration: 1, thenDragTo: app.navigationBars.firstMatch)
			let deleteButtons = app.tables.cells.buttons.matching{$0.label.contains("Delete") && ($0.label.contains("ℂKey²") == false)}
			var button = deleteButtons.allElementsBoundByIndex.last(where: {$0.isHittable})
			while deleteButtons.count > 0 {
				button?.tap()
				button = deleteButtons.allElementsBoundByIndex.last(where: {$0.isHittable})
			}
			let doneButton = app.navigationBars.buttons["Done"]
			if doneButton.exists && doneButton.isHittable {
				doneButton.tap()
			}
			return self
		}
	}
	#endif
}
#endif
