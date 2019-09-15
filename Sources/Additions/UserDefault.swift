//
//  UserDefault.swift
//  
//
//  Created by James Froggatt on 15/09/2019.
//

import Foundation

@propertyWrapper
public struct WritableUserDefault<Wrapped: Codable> {
	public var userDefaults: UserDefaults
	public var key: String
	public var defaultValue: Wrapped
	public var wrappedValue: Wrapped {
		get {userDefaults.value(forKey: key) as? Wrapped ?? defaultValue}
		set {userDefaults.set(newValue, forKey: key)}
	}
	
	public init(wrappedValue: Wrapped, _ key: String, in userDefaults: UserDefaults = .standard) {
		self.defaultValue = wrappedValue; self.userDefaults = userDefaults; self.key = key
	}
	
	public func removeStoredValue() {
		userDefaults.removeObject(forKey: key)
	}
}

@propertyWrapper
public struct UserDefault<Wrapped: Codable> {
	public var userDefaults: UserDefaults
	public var key: String
	public var defaultValue: Wrapped
	public var wrappedValue: Wrapped {
		userDefaults.value(forKey: key) as? Wrapped ?? defaultValue
	}
	
	public init(wrappedValue: Wrapped, _ key: String, in userDefaults: UserDefaults = .standard) {
		self.defaultValue = wrappedValue; self.userDefaults = userDefaults; self.key = key
	}
}
