//
//  AnyCollectionEditing.swift
//  Additions
//
//  Created by James Froggatt on 01.09.2016.
//
//
/*
public struct AnyCollectionEditing<Index: Hashable>: CollectionEditing {
	fileprivate var base: _CollectionEditing<Index>
	public init<CollectionEditing>(_ base: CollectionEditing) where
			CollectionEditing: Additions.CollectionEditing, CollectionEditing.Index == Index {
		self.base = __CollectionEditing(base)
	}
}
public extension AnyCollectionEditing {
	func insertItem(at index: Index) {base.insertItem(at: index)}
	func deleteItem(at index: Index) {base.deleteItem(at: index)}
	func cutItem(at index: Index) {base.cutItem(at: index)}
	func copyItem(at index: Index) {base.copyItem(at: index)}
	func pasteItem(at index: Index) {base.pasteItem(at: index)}
	func duplicateItem(at index: Index) {base.duplicateItem(at: index)}
}
fileprivate class _CollectionEditing<Index: Hashable>: CollectionEditing {
	func insertItem(at index: Index) {fatalError()}
	func deleteItem(at index: Index) {fatalError()}
	func cutItem(at index: Index) {fatalError()}
	func copyItem(at index: Index) {fatalError()}
	func pasteItem(at index: Index) {fatalError()}
	func duplicateItem(at index: Index) {fatalError()}
}
fileprivate class __CollectionEditing<Base: CollectionEditing>: _CollectionEditing<Base.Index> {
	var base: Base
	init(_ base: Base) {self.base = base}
	override func insertItem(at index: Base.Index) {base.insertItem(at: index)}
	override func deleteItem(at index: Base.Index) {base.deleteItem(at: index)}
	override func cutItem(at index: Base.Index) {base.cutItem(at: index)}
	override func copyItem(at index: Base.Index) {base.copyItem(at: index)}
	override func pasteItem(at index: Base.Index) {base.pasteItem(at: index)}
	override func duplicateItem(at index: Base.Index) {base.duplicateItem(at: index)}
}
*/
