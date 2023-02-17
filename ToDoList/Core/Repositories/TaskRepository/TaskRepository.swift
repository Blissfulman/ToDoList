//
//  TaskRepository.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 15.02.2023.
//

import Foundation

final class TaskMockRepository: IRepository {

	typealias Object = Task

	// MARK: - IRepository

	func getObjectList(completion: @escaping (Result<[Object], Error>) -> Void) {
		completion(.success(TaskMockRepository.mockTasks))
	}
}

private extension TaskMockRepository {

	// Временный метод для тестирования
	static var mockTasks: [Task] {
		let mockTasks: [Task] = mockRegularTasks + mockImportantTasks
		mockTasks
			.enumerated()
			.forEach { $1.isCompleted = $0.isMultiple(of: 2) }
		return mockTasks.shuffled()
	}

	// Временный метод для тестирования
	static var mockRegularTasks: [RegularTask] {
		[
			RegularTask(title: "To clean the room"),
			RegularTask(title: "Learning English"),
			RegularTask(title: "Walk"),
			RegularTask(title: "To wash the dishes")
		]
	}

	// Временный метод для тестирования
	static var mockImportantTasks: [ImportantTask] {
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
				title: "Relax",
				creationDate: Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())!,
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
