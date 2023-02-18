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
		let taskListDataSourceAdaptor = TaskListDataSourceAdaptor(
			taskManager: PrioritySortedTaskManagerDecorator(taskManager: taskManager),
			taskRepository: TaskRepositoryStub()
		)
		let presenter = TaskListPresenter(taskListDataSourceAdaptor: taskListDataSourceAdaptor)
		let viewController = TaskListViewController(presenter: presenter)
		presenter.view = viewController
		return viewController
	}
}
