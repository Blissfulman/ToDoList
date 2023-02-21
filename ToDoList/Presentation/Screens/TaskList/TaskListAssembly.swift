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
		let taskListSectionsAdapter = TaskListSectionsAdapter(
			taskManager: PrioritySortedTaskManagerDecorator(taskManager: taskManager),
			taskRepository: TaskRepositoryStub()
		)
		let presenter = TaskListPresenter(taskListSectionsAdapter: taskListSectionsAdapter)
		let viewController = TaskListViewController(presenter: presenter)
		presenter.view = viewController
		return viewController
	}
}
