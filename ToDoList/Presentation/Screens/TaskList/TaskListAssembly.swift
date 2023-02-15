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
		let magicCacheManager = MagicCacheManager()
		let presenter = TaskListPresenter(taskManager: taskManager, magicCacheManager: magicCacheManager)
		let viewController = TaskListViewController(presenter: presenter)
		presenter.view = viewController
		return viewController
	}
}
