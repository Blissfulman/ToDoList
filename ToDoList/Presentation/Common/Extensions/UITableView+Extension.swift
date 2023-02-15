//
//  UITableView+Extension.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

extension UITableView {

	func registerCell<T: UITableViewCell>(type: T.Type) {
		register(type, forCellReuseIdentifier: String(describing: type))
	}

	func dequeue<T: UITableViewCell>(type: T.Type, for indexPath: IndexPath) -> T? {
		dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as? T
	}
}
