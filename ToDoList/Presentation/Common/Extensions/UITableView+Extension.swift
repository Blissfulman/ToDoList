//
//  UITableView+Extension.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

extension UITableView {

	/// Регистрация класса ячейки.
	/// - Parameter type: Регистрируемый класс.
	func registerCell<T: UITableViewCell>(type: T.Type) {
		register(type, forCellReuseIdentifier: String(describing: type))
	}

	/// Возвращает переиспользуемый объект ячейки UITableView для указанного типа.
	/// - Parameters:
	///   - type: Тип ячейки.
	///   - indexPath: IndexPath ячейки.
	/// - Returns: Переиспользуемый объект ячейки.
	func dequeue<T: UITableViewCell>(type: T.Type, for indexPath: IndexPath) -> T? {
		dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as? T
	}
}
