//
//  SimplePickerSource.swift
//  StandardAdditions
//
//  Created by James Froggatt on 08.07.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

//inactive - just make a class
#if os(iOS) || os(tvOS)
	import UIKit

	open class SimplePickerSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
		
		public typealias Index = (component: Int, row: Int)
		open let count: Index
		open let generateTitle: (Index) -> String
		open var selectionHandler: ((Index) -> ())?
		
		public init(count: Index, title: @escaping (Index) -> String) {
			self.count = count
			self.generateTitle = title
		}
		public convenience init(rowCount: Int, title: @escaping (Int) -> String) {
			self.init(count: (1, rowCount), title: {title($0.row)})
		}
		public convenience init(items: String...) {
			self.init(rowCount: items.count, title: {items[$0]})
		}
		
		public func numberOfComponents(in pickerView: UIPickerView) -> Int {
			return count.component
		}
		public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
			return count.row
		}
		public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
			return generateTitle((component, row))
		}
		public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
			selectionHandler?((component, row))
		}
	}
#endif
