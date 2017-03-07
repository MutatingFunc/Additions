//
//  CollectionModels.swift
//  StandardAdditions
//
//  Created by James Froggatt on 17.08.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

import Foundation

public protocol CollectionBasicEditing {
	associatedtype Index: Hashable = Int
	
	func insertItem(at index: Index)
	func deleteItem(at index: Index)
	
	func duplicateItem(at index: Index)
}
public protocol CollectionEditing {
	associatedtype Index: Hashable = Int
	
	func insertItem(at index: Index)
	func deleteItem(at index: Index)
	
	func cutItem(at index: Index)
	func copyItem(at index: Index)
	func pasteItem(at index: Index)
	func duplicateItem(at index: Index)
}
public extension CollectionEditing {
	func cutItem(at index: Index) {
		copyItem(at: index)
		deleteItem(at: index)
	}
}

public protocol CollectionBasicSourcing: CollectionBasicEditing {
	associatedtype Items: RangeReplaceableCollection
	typealias Item = Items.Iterator.Element
	
	var items: Items {get nonmutating set}
	
	func newItem() -> Item
	func newCopy(of item: Item) -> Item
	
	associatedtype CollectionView: CollectionEditing
	var sourcedView: CollectionView {get}
	func displayIndex(for index: Index) -> CollectionView.Index
}

public protocol CollectionSourcing: CollectionBasicSourcing, CollectionEditing {
	var pasteboard: Item? {get nonmutating set}
}

public extension CollectionBasicSourcing where Index == Items.Index, Index == Int, CollectionView.Index == IndexPath {
	func displayIndex(for index: Index) -> CollectionView.Index {return IndexPath(row: index)}
}
public extension CollectionBasicSourcing where Index == Items.Index, Index == CollectionView.Index {
	func displayIndex(for index: Index) -> CollectionView.Index {return index}
}
public extension CollectionBasicSourcing where Items.Iterator.Element: Copyable {
	///Default implementation for models implementing Copyable
	func newCopy(of item: Item) -> Item {
		return item.copy()
	}
}
public extension CollectionBasicSourcing where Index == Items.Index {
	func insertItem(at index: Index) {cs_insertItem(at: index)}
	func deleteItem(at index: Index) {cs_deleteItem(at: index)}
	func duplicateItem(at index: Index) {cs_duplicateItem(at: index)}
	
	func cs_insertItem(at index: Index) {
		items.insert(newItem(), at: index)
		sourcedView.insertItem(at: displayIndex(for: index))
	}
	func cs_deleteItem(at index: Index) {
		items.remove(at: index)
		sourcedView.deleteItem(at: displayIndex(for: index))
	}
	func cs_duplicateItem(at index: Index) {
		let copyIndex = items.index(after: index)
		items.insert(newCopy(of: items[index]), at: copyIndex)
		sourcedView.duplicateItem(at: displayIndex(for: copyIndex))
	}
}

public extension CollectionSourcing where Index == Items.Index {
	func cutItem(at index: Index) {cs_cutItem(at: index)}
	func copyItem(at index: Index) {cs_copyItem(at: index)}
	func pasteItem(at index: Index) {cs_pasteItem(at: index)}
	
	func cs_cutItem(at index: Index) {
		copyItem(at: index)
		items.remove(at: index)
		sourcedView.cutItem(at: displayIndex(for: index))
	}
	func cs_copyItem(at index: Index) {
		pasteboard = items[index]
		sourcedView.copyItem(at: displayIndex(for: index))
	}
	func cs_pasteItem(at index: Index) {
		guard let pasteboard = pasteboard else {return}
		items.insert(newCopy(of: pasteboard), at: index)
		sourcedView.pasteItem(at: displayIndex(for: index))
	}
}
