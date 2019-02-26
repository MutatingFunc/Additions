//
//  ReusableContainerCells.swift
//  Additions
//
//  Created by James Froggatt on 30.01.2019.
//

#if canImport(UIKit)
import UIKit

public class TableViewCell<ViewType: UIView>: UITableViewCell {
	private var containedView: ViewType!
	public func setContent(_ view: ViewType) {
		precondition(self.containedView == nil, "Content should only be set once")
		self.containedView = view
		containedView.frame = self.contentView.bounds
		containedView.translatesAutoresizingMaskIntoConstraints = true
		containedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.contentView.addSubview(containedView)
	}
}

public class CollectionViewCell<ViewType: UIView>: UICollectionViewCell {
	private var containedView: ViewType!
	public func setContent(_ view: ViewType) {
		precondition(self.containedView == nil, "Content should only be set once")
		self.containedView = view
		containedView.frame = self.contentView.bounds
		containedView.translatesAutoresizingMaskIntoConstraints = true
		containedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.contentView.addSubview(containedView)
	}
}
#endif
