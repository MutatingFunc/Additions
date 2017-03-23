//
//  Foundation.swift
//  Additions
//
//  Created by James Froggatt on 27.09.2016.
//
//

import Foundation

public extension IndexPath {
	init(row: Int) {
		self.init(indexes: [0, row])
	}
	init(item: Int) {
		self.init(indexes: [0, item])
	}
}

public extension UserDefaults {
	func setValue<T>(_ value: Any?, forKey key: T) where
			T: RawRepresentable, T.RawValue == String {
		return self.setValue(value, forKey: key.rawValue)
	}
	func value<T>(forKey key: T) -> Any? where
			T: RawRepresentable, T.RawValue == String {
		return self.value(forKey: key.rawValue)
	}
}
