//
//  Foundation.swift
//  Additions
//
//  Created by James Froggatt on 27.09.2016.
//
//

import Foundation

public extension IndexPath {
	init<I: BinaryInteger>(row: I) {
		self.init(indexes: [0, Int(row)])
	}
	init<I: BinaryInteger>(item: I) {
		self.init(indexes: [0, Int(item)])
	}
}

public extension JSONDecoder {
	func decode<Decodable: Swift.Decodable>(from data: Data) throws -> Decodable {
		return try self.decode(Decodable.self, from: data)
	}
}
