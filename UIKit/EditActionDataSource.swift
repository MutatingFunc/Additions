//
//  EditActionDataSource.swift
//  Additions
//
//  Created by James Froggatt on 21.05.2017.
//
//

public protocol EditActionHandler: AnyObject {
	func insertItem(at indices: Set<Int>)
	func deleteItem(at index: Set<Int>)
}
public protocol EditActionDataSource: EditActionHandler {
	associatedtype Item
	var items: [Item] {get set}
	func makeItem() -> Item
}
public extension EditActionDataSource {
	func insertItem(at indices: Set<Int>) {
		for index in indices.sorted(by: >) {
			items.insert(makeItem(), at: index)
		}
	}
	func deleteItem(at indices: Set<Int>) {
		for index in indices.sorted(by: >) {
			items.remove(at: index)
		}
	}
}

public protocol CopyingEditActionHandler: EditActionHandler {
	func duplicateItem(at indices: Set<Int>)
	func pasteItem(at index: Int)
	func copyItem(at indices: Set<Int>)
	func cutItem(at indices: Set<Int>)
}
public protocol CopyingEditActionDataSource: EditActionDataSource, CopyingEditActionHandler {
	var pasteboard: [Item] {get set}
	func makeCopy(of item: Item) -> Item
}
public extension CopyingEditActionDataSource {
	func duplicateItem(at indices: Set<Int>) {
		for index in indices.sorted(by: >) {
			items.insert(items[index], at: index+1)
		}
	}
	func cutItem(at indices: Set<Int>) {
		pasteboard = []
		pasteboard.reserveCapacity(indices.count)
		for index in indices.sorted(by: >) {
			pasteboard.append(items.remove(at: index))
		}
		pasteboard.reverse()
	}
	func copyItem(at indices: Set<Int>) {
		pasteboard = []
		pasteboard.reserveCapacity(indices.count)
		for index in indices.sorted(by: >) {
			pasteboard.append(items[index])
		}
		pasteboard.reverse()
	}
	func pasteItem(at index: Int) {
		items.insert(contentsOf: pasteboard, at: index)
	}
}
