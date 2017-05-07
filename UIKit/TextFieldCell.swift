//
//  TextFieldCell.swift
//  Additions
//
//  Created by James Froggatt on 30.04.2017.
//
//

import UIKit

public class TextFieldCell: UITableViewCell, ReuseIdentifiable {
	@IBOutlet public var textField: UITextField? {
		didSet {
			textField?.addTarget(self, action: #selector(textChanged), for: .editingChanged)
			updateTextField()
		}
	}
	
	fileprivate var onChange: (String) -> () = {_ in}
	public func setText(_ text: String, onChange: @escaping (String) -> ()) {
		self.onChange = {_ in}
		textField?.text = text
		self.onChange = onChange
	}
	
	func textChanged(_ textField: UITextField) {
		onChange(textField.text ?? "")
	}
	
	override public func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		updateTextField()
	}
	func updateTextField() {
		textField?.borderStyle = isEditing ? .roundedRect : .none
		textField?.isEnabled = isEditing
	}
}
