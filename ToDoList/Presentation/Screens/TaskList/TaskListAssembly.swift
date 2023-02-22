//
//  TaskListAssembly.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

final class TaskListAssembly {

	func assemble() -> UIViewController {
		let presenter = TaskListPresenter()

		let taskManager = TaskManager()
		let taskListSectionsAdapter = TaskListSectionsAdapter(taskManager: PrioritySortedTaskManagerDecorator(taskManager: taskManager))
		let interactor = TaskListInteractor(
			presenter: presenter,
			taskRepository: TaskRepositoryStub(),
			taskListSectionsAdapter: taskListSectionsAdapter
		)

		let viewController = TaskListViewController(interactor: interactor)
		presenter.view = viewController
		return viewController
	}
}
