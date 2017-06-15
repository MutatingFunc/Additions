//
//  Reuseable.swift
//  StandardAdditions
//
//  Created by James Froggatt on 11.06.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

#if os(iOS) || os(tvOS)
	import UIKit

	public protocol ReuseIdentifiable {
		static var reuseID: String {get}
	}
	public extension ReuseIdentifiable where Self: UIView {
		static var reuseID: String {return String(describing: self)}
	}

	public extension UITableView {
		func register(cell cellClass: (UITableViewCell & ReuseIdentifiable).Type) {
			self.register(cellClass, forCellReuseIdentifier: cellClass.reuseID)
		}
		func dequeueReusableCell<Identifiable: UITableViewCell & ReuseIdentifiable>(for indexPath: IndexPath) -> Identifiable! {
			return self.dequeueReusableCell(withIdentifier: Identifiable.reuseID, for: indexPath) as? Identifiable
		}
		
		func dequeueReusableHeaderFooterView<Identifiable: UITableViewHeaderFooterView & ReuseIdentifiable>() -> Identifiable! {
			return self.dequeueReusableHeaderFooterView(withIdentifier: Identifiable.reuseID) as? Identifiable
		}
	}

	public extension UICollectionView {
		func register(cell cellClass: (UICollectionViewCell & ReuseIdentifiable).Type) {
			self.register(cellClass, forCellWithReuseIdentifier: cellClass.reuseID)
		}
		func dequeueReusableCell<Identifiable: UICollectionViewCell & ReuseIdentifiable>(for indexPath: IndexPath) -> Identifiable! {
			return self.dequeueReusableCell(withReuseIdentifier: Identifiable.reuseID, for: indexPath) as? Identifiable
		}
		func dequeueReusableSupplementaryView<Identifiable: UICollectionReusableView & ReuseIdentifiable>(ofKind kind: String, for indexPath: IndexPath) -> Identifiable! {
			return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Identifiable.reuseID, for: indexPath) as? Identifiable
		}
	}
	
	@available(iOSApplicationExtension 11.0, *)
	public extension UITableViewDropCoordinator {
		func drop<Identifiable: UITableViewCell & ReuseIdentifiable>(_ dragItem: UIDragItem, toPlaceholderInsertedAt indexPath: IndexPath, ofType: Identifiable.Type, rowHeight: CGFloat, cellUpdateHandler: @escaping (Identifiable!) -> Void) -> UITableViewDropPlaceholderContext {
			return self.drop(dragItem, toPlaceholderInsertedAt: indexPath, withReuseIdentifier: Identifiable.reuseID, rowHeight: rowHeight, cellUpdateHandler: {cellUpdateHandler($0 as? Identifiable)})
		}
	}
	@available(iOSApplicationExtension 11.0, *)
	public extension UICollectionViewDropCoordinator {
		func drop<Identifiable: UICollectionViewCell & ReuseIdentifiable>(_ dragItem: UIDragItem, toPlaceholderInsertedAt indexPath: IndexPath, ofType: Identifiable.Type, cellUpdateHandler: @escaping (Identifiable!) -> Void) -> UICollectionViewDropPlaceholderContext {
			return self.drop(dragItem, toPlaceholderInsertedAt: indexPath, withReuseIdentifier: Identifiable.reuseID, cellUpdateHandler: {cellUpdateHandler($0 as? Identifiable)})
		}
	}
#endif
