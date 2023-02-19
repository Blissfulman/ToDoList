//
//  ConfigurableTableCell.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

/// Конфигурируемая ячейка таблицы.
protocol IConfigurableTableCell: UITableViewCell {
	associatedtype ConfigurationModel

	/// Конфигурация ячейки.
	/// - Parameter model: Модель данных ячейки.
	func configure(with model: ConfigurationModel)
}
