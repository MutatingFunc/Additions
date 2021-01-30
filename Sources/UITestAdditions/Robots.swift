//
//  Robots.swift
//  Additions
//
//  Created by James Froggatt on 19.05.2019.
//

#if canImport(XCTest) && os(iOS) && !TARGET_OS_MACCATALYST
import XCTest

public struct HomeScreenRobot: Robot {
	public init() {
		XCUIDevice.shared.press(.home)
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
	public func setDefaultKeyboard(_ keyboardName: String, extensionBundleID: String) -> Self {
		action {
			if app.staticTexts["General"].exists {
				app.staticTexts["General"].tap()
				app.staticTexts["Keyboard"].tap()
				app.staticTexts["Keyboards"].tap()
			}
			let keyboardCell = app.cells[extensionBundleID]
			if keyboardCell.exists == false {
				app.staticTexts["Add New Keyboard..."].tap()
				let addCell = app.staticTexts.matching(identifier: keyboardName) //Multiple matches when view is modal
				addCell.allElementsBoundByIndex.forEach {
					if $0.isHittable {
						$0.tap()
					}
				}
			}
			app.navigationBars.buttons["Edit"].tap()
			keyboardCell.buttons["Reorder " + keyboardName].press(forDuration: 1, thenDragTo: app.navigationBars.firstMatch)
			let deleteButtons = app.tables.cells.buttons.matching{$0.label.contains("Delete") && ($0.label.contains(keyboardName) == false)}
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
	
	@discardableResult
	public func setDarkMode(_ enabled: Bool) -> Self {
		action {
			let developerButton = app.cells["Developer"]
			developerButton.scrollTo(in: app.tables.firstMatch)
			developerButton.tap()
			let darkModeSwitch = app.switches["Dark Appearance"]
			if (darkModeSwitch.value as? String == "1") != enabled {
				darkModeSwitch.tap()
			}
			return self
		}
	}
	#endif
}
#endif
