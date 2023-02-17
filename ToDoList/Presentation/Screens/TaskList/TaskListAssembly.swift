//
//  TaskListAssembly.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

final class TaskListAssembly {

	func assemble() -> UIViewController {
		let taskManager = TaskManager()
		// Временно для тестирования
		let taskRepository = TaskMockRepository().eraseToAnyRepository()
		let taskListDataSourceLayout = TaskListDataSourceLayout(taskManager: taskManager, taskRepository: taskRepository)
		let taskListDataSource = TaskListDataSource(taskListDataSourceLayout: taskListDataSourceLayout)
		let viewController = TaskListViewController(taskListDataSource: taskListDataSource)
		return viewController
	}
}
