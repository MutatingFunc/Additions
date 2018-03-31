//
//  EditActionGenerator.swift
//  Additions
//
//  Created by James Froggatt on 21.05.2017.
//
//

/*
inactive - drag & drop APIs make native alternatives appealing
*/

#if canImport(UIKit)
import UIKit

public struct BasicEditActionGenerator {
	public func rowActions(_ handlers: EditActionHandler...) -> [UITableViewRowAction] {
		return [
			UITableViewRowAction(style: .destructive, title: "Delete", handler: {_, indexPath in handlers.forEach{$0.deleteItem(at: [indexPath.row])}})
		]
	}
	
	public func editActions(indices: Set<Int>, _ handlers: EditActionHandler...) -> [UIAlertAction] {
		return [
			UIAlertAction(title: "Insert", style: .default, handler: {_ in handlers.forEach{$0.insertItem(at: indices)}}),
			UIAlertAction(title: "Delete", style: .destructive, handler: {_ in handlers.forEach{$0.deleteItem(at: indices)}})
		]
	}
}

public struct CopyingEditActionGenerator {
	public func rowActions(_ handlers: CopyingEditActionHandler...) -> [UITableViewRowAction] {
		return [
			UITableViewRowAction(style: .destructive, title: "Cut", handler: {_, indexPath in handlers.forEach{$0.cutItem(at: [indexPath.row])}})
		]
	}
	
	public func editActions(indices: Set<Int>, _ handlers: CopyingEditActionHandler...) -> [UIAlertAction] {
		func action(_ action: @escaping (CopyingEditActionHandler) -> (Set<Int>) -> ()) -> (UIAlertAction) -> () {
			return {_ in
				for handler in handlers {
					action(handler)(indices)
				}
			}
		}
		var actions = [
			UIAlertAction(title: "Duplicate", style: .default, handler: {_ in handlers.forEach{$0.duplicateItem(at: indices)}})
		]
		if indices.count == 1, let index = indices.first {
			actions.append(UIAlertAction(title: "Paste", style: .default, handler: {_ in handlers.forEach{$0.pasteItem(at: index)}}))
		}
		actions += [
			UIAlertAction(title: "Copy", style: .default, handler: {_ in handlers.forEach{$0.copyItem(at: indices)}}),
			UIAlertAction(title: "Cut", style: .destructive, handler: {_ in handlers.forEach{$0.cutItem(at: indices)}}),
			UIAlertAction(title: "Delete", style: .destructive, handler: {_ in handlers.forEach{$0.deleteItem(at: indices)}}),
			UIAlertAction(title: "Insert", style: .default, handler: {_ in handlers.forEach{$0.insertItem(at: indices)}})
		]
		return actions
	}
}

//extensions

fileprivate func paths(_ indices: Set<Int>) -> [IndexPath] {
	return indices.map(IndexPath.init(item:))
}

extension UITableView: CopyingEditActionHandler {
	public func insertItem(at indices: Set<Int>) {
		insertRows(at: paths(indices), with: .right)
	}
	public func deleteItem(at indices: Set<Int>) {
		deleteRows(at: paths(indices), with: .right)
	}
	
	public func cutItem(at indices: Set<Int>) {
		deleteRows(at: paths(indices), with: .left)
	}
	public func copyItem(at indices: Set<Int>) {}
	public func pasteItem(at index: Int) {
		insertRows(at: [IndexPath(row: index)], with: .left)
	}
	public func duplicateItem(at indices: Set<Int>) {
		insertRows(at: paths(indices), with: .top)
	}
}

extension UICollectionView: CopyingEditActionHandler {
	public func insertItem(at indices: Set<Int>) {
		insertItems(at: paths(indices))
	}
	public func deleteItem(at indices: Set<Int>) {
		deleteItems(at: paths(indices))
	}
	
	public func cutItem(at indices: Set<Int>) {
		deleteItems(at: paths(indices))
	}
	public func copyItem(at indices: Set<Int>) {}
	public func pasteItem(at index: Int) {
		insertItems(at: [IndexPath(row: index)])
	}
	public func duplicateItem(at indices: Set<Int>) {
		insertItems(at: paths(indices))
	}
}
#endif
