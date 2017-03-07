//
//  AutoSource.swift
//  StandardAdditions
//
//  Created by James Froggatt on 23.06.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

#if os(iOS) || os(tvOS)
	import UIKit
	
	//public typealias EditableCollectionView = AnyCollectionEditing<IndexPath>

	public extension CollectionSourcing where Self: UITableViewController {
		var sourcedView: UITableView {return self.tableView}
	}
	public extension CollectionSourcing where Self: UICollectionViewController {
		var sourcedView: UICollectionView {return self.collectionView!}
	}
	
	extension UITableView: CollectionEditing {}
	public extension UITableView {
		func insertItem(at index: IndexPath) {
			insertRows(at: [index], with: .right)
		}
		func deleteItem(at index: IndexPath) {
			deleteRows(at: [index], with: .right)
		}
		
		func cutItem(at index: IndexPath) {
			deleteRows(at: [index], with: .left)
		}
		func copyItem(at index: IndexPath) {}
		func pasteItem(at index: IndexPath) {
			insertRows(at: [index], with: .left)
		}
		func duplicateItem(at index: IndexPath) {
			insertRows(at: [index], with: .top)
		}
	}
	
	extension UICollectionView: CollectionEditing {}
	public extension UICollectionView {
		func insertItem(at index: IndexPath) {
			insertItems(at: [index])
		}
		func deleteItem(at index: IndexPath) {
			deleteItems(at: [index])
		}
		
		func cutItem(at index: IndexPath) {
			cutItems(at: [index])
		}
		func copyItem(at index: IndexPath) {}
		func pasteItem(at index: IndexPath) {
			pasteItems(at: [index])
		}
		func duplicateItem(at index: IndexPath) {
			duplicateItems(at: [index])
		}
		
		func cutItems(at indices: [IndexPath]) {
			deleteItems(at: indices)
		}
		func copyItems(at indices: [IndexPath]) {}
		func pasteItems(at indices: [IndexPath]) {
			insertItems(at: indices)
		}
		func duplicateItems(at indices: [IndexPath]) {
			insertItems(at: indices)
		}
	}
#endif
