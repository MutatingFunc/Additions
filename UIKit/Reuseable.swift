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
		func register(cell cellClass: (AnyObject & ReuseIdentifiable).Type) {
			self.register(cellClass, forCellReuseIdentifier: cellClass.reuseID)
		}
		func dequeueReusableCell<Identifiable>(at indexPath: IndexPath) -> Identifiable! where
				Identifiable: UITableViewCell, Identifiable: ReuseIdentifiable {
			return self.dequeueReusableCell(withIdentifier: Identifiable.reuseID, for: indexPath) as? Identifiable
		}
		
		func dequeueReusableHeaderFooterView<Identifiable>() -> Identifiable! where
				Identifiable: UITableViewHeaderFooterView, Identifiable: ReuseIdentifiable {
			return self.dequeueReusableHeaderFooterView(withIdentifier: Identifiable.reuseID) as? Identifiable
		}
	}

	public extension UICollectionView {
		func register(cell cellClass: (AnyObject & ReuseIdentifiable).Type) {
			self.register(cellClass, forCellWithReuseIdentifier: cellClass.reuseID)
		}
		func dequeueReusableCell<Identifiable>(at indexPath: IndexPath) -> Identifiable! where
				Identifiable: UICollectionViewCell, Identifiable: ReuseIdentifiable {
			return self.dequeueReusableCell(withReuseIdentifier: Identifiable.reuseID, for: indexPath) as? Identifiable
		}
	}
#endif
