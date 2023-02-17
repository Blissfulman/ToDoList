//
//  ImportantTask.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import Foundation

final class ImportantTask: Task {

	// MARK: - Nested types

	enum Priority: Comparable {
		case low
		case medium
		case high
	}

	// Properties
	let priority: Priority
	private let creationDate: Date

	var executionDate: Date? {
		switch priority {
		case .low:
			return Calendar.current.date(byAdding: DateComponents(day: 3), to: creationDate)
		case .medium:
			return Calendar.current.date(byAdding: DateComponents(day: 2), to: creationDate)
		case .high:
			return Calendar.current.date(byAdding: DateComponents(day: 1), to: creationDate)
		}
	}

	var isExpired: Bool {
		// Сравнение со вчерашним днём, чтобы задача с дедлайном на сегодня не считалась с уже истёкшим сроком дедлайна
		guard let executionDate = executionDate,
			  let currentDate = Calendar.current.date(byAdding: DateComponents(day: -1), to: Date()) else { return false }
		return executionDate < currentDate
	}

	// MARK: - Init

	init(title: String, creationDate: Date, priority: Priority) {
		self.creationDate = creationDate
		self.priority = priority
		super.init(title: title)
	}
}
