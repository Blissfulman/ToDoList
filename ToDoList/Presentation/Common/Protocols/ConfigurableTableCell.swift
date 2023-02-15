//
//  ConfigurableTableCell.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

protocol IConfigurableTableCell: UITableViewCell {
	associatedtype ConfigurationModel

	/// Конфигурация яцейки.
	/// - Parameter model: Модель данных ячейки.
	func configure(with model: ConfigurationModel)
}
