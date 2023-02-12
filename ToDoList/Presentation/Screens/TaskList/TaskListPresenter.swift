//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

protocol ITaskListPresenter: AnyObject {
	/// Количество задач.
	var taskCount: Int { get }

	/// Вью загружено.
	func viewDidLoad()
	/// Получение модели задачи по индексу.
	/// - Parameter index: Индекс.
	/// - Returns: При наличии задачи по переданному индексу возвращается задача `Task`, в противном случае — `nil`.
	func task(at index: Int) -> Task?
	/// Получение индекса задачи по модели.
	/// - Parameter task: Задача `Task`.
	/// - Returns: При обнаружении в списке переданной задачи возвращается её индекс в списке, в противном случае — `nil`.
	func index(for task: Task) -> Int?
}

final class TaskListPresenter: ITaskListPresenter {

	// Properties
	weak var view: ITaskListView?
	private let taskManager: ITaskManager
	private let magicCacheManager: IMagicCacheManager

	var taskCount: Int {
		taskManager.allTasks.count
	}

	// MARK: - Init

	init(taskManager: ITaskManager, magicCacheManager: IMagicCacheManager) {
		self.taskManager = taskManager
		self.magicCacheManager = magicCacheManager
	}

	// MARK: - ITaskListPresenter

	func viewDidLoad() {
		taskManager.addTasks(magicCacheManager.getTasks())
		view?.reloadData()
	}

	func task(at index: Int) -> Task? {
		guard index < taskManager.allTasks.count else { return nil }
		return taskManager.allTasks[index]
	}

	func index(for task: Task) -> Int? {
		taskManager.allTasks.firstIndex(where: { $0 === task })
	}
}
