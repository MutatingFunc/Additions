//
//  Regex.swift
//  Additions
//
//  Created by James Froggatt on 20.08.2016.
//
//

/*
inactive
• no valid use found (see String.CompareOptions.regularExpression)
*/

import Foundation

public struct RegEx: ExpressibleByStringLiteral {
	public var pattern: String
	public var options: NSRegularExpression.Options
	public init(stringLiteral value: String) {
		self.pattern = value
		self.options = [.caseInsensitive]
	}
	public init(extendedGraphemeClusterLiteral value: String) {
		self.init(stringLiteral: value)
	}
	public init(unicodeScalarLiteral value: String) {
		self.init(stringLiteral: value)
	}
	public init(_ pattern: String, options: NSRegularExpression.Options = []) {
		self.pattern = pattern
		self.options = options
	}
	
	public func matches(_ string: String, options: NSRegularExpression.MatchingOptions = []) -> Bool {
		return try! NSRegularExpression(pattern: self.pattern, options: self.options)
			.firstMatch(in: string, options: options, range: range(string)) != nil
	}
}
public func ~=(pattern: RegEx, matched: String) -> Bool {
	return pattern.matches(matched)
}

private func range(_ string: String) -> NSRange {
	return NSRange(location: 0, length: (string as NSString).length)
}
