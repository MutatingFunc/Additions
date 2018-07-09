//
//  NeverConformances.swift
//  Additions
//
//  Created by James Froggatt on 24.05.2018.
//

import Foundation

extension Never: Equatable {
	public static func == (lhs: Never, rhs: Never) -> Bool {switch (lhs, rhs) {}}
}
extension Never: Comparable {
	public static func < (lhs: Never, rhs: Never) -> Bool {switch (lhs, rhs) {}}
}
extension Never: Hashable {
	#if swift(>=4.2)
	public func hash(into hasher: inout Hasher) {switch self {}}
	#else
	public var hashValue: Int {switch self {}}
	#endif
}
extension Never: Error {}
extension Never: CustomStringConvertible {
	public var description: String {switch self {}}
}
extension Never: RandomAccessCollection, MutableCollection {
	//can't use Never for associated types without warnings
	public var startIndex: Int {switch self {}}
	public var endIndex: Int {switch self {}}
	public func index(before i: Int) -> Int {switch self {}}
	public func index(after i: Int) -> Int {switch self {}}
	public func index(_ i: Int, offsetBy n: Int) -> Int {switch self {}}
	public subscript(position: Int) -> () {
		get {switch self {}}
		set {switch self {}}
	}
}/*
extension Never: Strideable {
	public func advanced(by n: Int) -> Never {switch self {}}
	public func distance(to other: Never) -> Int {switch self {}}
}*/
