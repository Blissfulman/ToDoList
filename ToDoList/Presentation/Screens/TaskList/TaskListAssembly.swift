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
		let taskListDataSourceLayout = TaskListDataSourceLayout(
			taskManager: taskManager,
			prioritySortedTaskManagerDecorator: PrioritySortedTaskManagerDecorator(taskManager: taskManager),
			taskRepository: TaskRepositoryStub()
		)
		let taskListDataSource = TaskListDataSource(taskListDataSourceLayout: taskListDataSourceLayout)
		let viewController = TaskListViewController(taskListDataSource: taskListDataSource)
		return viewController
	}
}
