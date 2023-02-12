//
//  MagicCacheManager.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import Foundation

protocol IMagicCacheManager: AnyObject {
	/// Получение задач из кеша.
	/// - Returns: Задачи, полученные из кеша.
	func getTasks() -> [Task]
}

/// Класс для имитации хранения задач в постоянном хранилище.
final class MagicCacheManager: IMagicCacheManager {

	// Метод для метод для тестирования
	func getTasks() -> [Task] {
		var mockTasks = RegularTask.mockData() + ImportantTask.mockData()
		mockTasks.enumerated().forEach { $1.isCompleted = $0.isMultiple(of: 2) }
		mockTasks.shuffle()
		return mockTasks
	}
}

private extension RegularTask {

	// Временный метод для тестирования
	static func mockData() -> [RegularTask] {
		[
			RegularTask(title: "To clean the room"),
			RegularTask(title: "Learning English"),
			RegularTask(title: "Walk"),
			RegularTask(title: "To wash the dishes")
		]
	}
}

private extension ImportantTask {

	// Временный метод для тестирования
	static func mockData() -> [ImportantTask] {
		[
			ImportantTask(
				title: "Workout",
				creationDate: Calendar.current.date(byAdding: DateComponents(day: -2), to: Date())!,
				priority: .medium
			),
			ImportantTask(
				title: "To fix shoes",
				creationDate: Calendar.current.date(byAdding: DateComponents(day: -5), to: Date())!,
				priority: .medium
			),
			ImportantTask(
				title: "Homework",
				creationDate: Date(),
				priority: .high
			),
			ImportantTask(
				title: "To bake coockies and three cakes (for two lines in title)",
				creationDate: Calendar.current.date(byAdding: DateComponents(day: -4), to: Date())!,
				priority: .low
			)
		]
	}
}
