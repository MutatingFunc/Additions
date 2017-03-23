//
//  AutoActions.swift
//  StandardAdditions
//
//  Created by James Froggatt on 11.06.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

#if os(iOS)
	import UIKit
	
	public extension CollectionSourcing where Index == Items.Index, Self: UIViewController {
		func editActions(forRow index: Index, menuSource sourceView: UITableViewCell?) -> [UITableViewRowAction] {
			return self.editActions(forRow: index, menuSource: sourceView, in: self)
		}
	}
	public extension CollectionSourcing where Index == Items.Index, Self: AnyObject {
		fileprivate var hasPasteboard: () -> Bool {return {[weak self] in self?.pasteboard != nil}}
		
		func editActions(forRow index: Index, menuSource sourceView: UITableViewCell?, in vc: UIViewController) -> [UITableViewRowAction] {
			return self.editActions(forRow: index, menuSource: sourceView, in: vc, hasPasteboard: hasPasteboard)
		}
		
		func editActions(forItem index: Index) -> [UIAlertAction] {
			return editActions(forItem: index, hasPasteboard: hasPasteboard)
		}
	}
	
	public extension CollectionEditing where Self: UIViewController {
		func editActions(forRow index: Index, menuSource sourceView: UITableViewCell?, hasPasteboard: @escaping () -> Bool) -> [UITableViewRowAction] {
			return self.editActions(forRow: index, menuSource: sourceView, in: self, hasPasteboard: hasPasteboard)
		}
	}
	
	public extension CollectionEditing where Self: AnyObject {
		func editActions(forRow index: Index, menuSource sourceView: UITableViewCell?, in vc: UIViewController, hasPasteboard: @escaping () -> Bool) -> [UITableViewRowAction] {
			return [
				UITableViewRowAction(style: .default, title: "Cut", handler: self.editActionHandler(index, action: Self.cutItem)),
				UITableViewRowAction(style: .normal, title: "Edit") {[weak self, weak vc] _, path in
					guard let vc = vc else {return precondition(false, "ViewController to display edit menu disappeared")}
					self!.presentEditMenu(forRow: index, from: sourceView, in: vc, hasPasteboard: hasPasteboard)
				}
			]
		}
		
		func presentEditMenu(forRow index: Index, from sourceView: UITableViewCell?, in vc: UIViewController, hasPasteboard: @escaping () -> Bool) {
			let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
			editActions(forItem: index, hasPasteboard: hasPasteboard)
				.forEach(alert.addAction)
			
			alert.present(in: vc, animated: true)
			if let ppc = alert.popoverPresentationController {
				sourceView ?=> ppc.setSource
				ppc.permittedArrowDirections = UIPopoverArrowDirection.any.subtracting(.right) //cell may slide behind master in split views
			}
		}
		
		func editActions(forItem index: Index, hasPasteboard: @escaping () -> Bool) -> [UIAlertAction] {
			let handler = {self.editActionHandler(index, taking: UIAlertAction.self, action: $0)}
			
			var items = [
				UIAlertAction(title: "Duplicate", style: .default, handler: handler(Self.duplicateItem))
			]
			if hasPasteboard() {
				items.append(UIAlertAction(title: "Paste", style: .default, handler: handler(Self.pasteItem)))
			}
			items += [
				UIAlertAction(title: "Copy", style: .default, handler: handler(Self.copyItem)),
				UIAlertAction(title: "Cut", style: .destructive, handler: handler(Self.cutItem)),
				UIAlertAction(title: "Delete", style: .destructive, handler: handler(Self.deleteItem)),
				UIAlertAction(title: "Insert", style: .default, handler: handler(Self.insertItem)),
				UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			]
			return items
		}
		
		func editActionHandler<A>(_ index: Index, taking type: A.Type = A.self, action: @escaping (Self) -> (Index) -> ()) -> (A) -> () {
			return {[weak self] _ in _ = (self ?=> action)?(index)}
		}
	}
#endif
