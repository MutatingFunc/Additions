//
//  ReusableContainerCells.swift
//  Additions
//
//  Created by James Froggatt on 30.01.2019.
//

#if canImport(UIKit)
import UIKit

public class TableViewCell<ViewType: UIView>: UITableViewCell, ReuseIdentifiable {
	private var containedView: ViewType!
	public func withInitialContent(_ view: ViewType) -> Self {
		if self.containedView == nil {
			return self.withContent(view)
		}
		return self
	}
	public func withContent(_ view: ViewType) -> Self {
		if self.containedView === view {
			return self
		} else {
			self.containedView?.removeFromSuperview()
		}
		view.removeFromSuperview()
		self.containedView = view
		containedView.frame = self.contentView.bounds
		containedView.translatesAutoresizingMaskIntoConstraints = true
		containedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.contentView.addSubview(containedView)
		return self
	}
}

public class CollectionViewCell<ViewType: UIView>: UICollectionViewCell, ReuseIdentifiable {
	private var containedView: ViewType!
	public func withInitialContent(_ view: ViewType) -> Self {
		if self.containedView == nil {
			return self.withContent(view)
		}
		return self
	}
	public func withContent(_ view: ViewType) -> Self {
		if self.containedView === view {
			return self
		} else {
			self.containedView?.removeFromSuperview()
		}
		view.removeFromSuperview()
		self.containedView = view
		containedView.frame = self.contentView.bounds
		containedView.translatesAutoresizingMaskIntoConstraints = true
		containedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.contentView.addSubview(containedView)
		return self
	}
}
#endif
