//
//  TaskListDataSourceLayout.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 15.02.2023.
//

import Foundation

protocol ITaskListDataSourceLayoutDelegate: AnyObject {
	/// Определяет необходимость разделения завершённых и незавершённых задач в разные секции.
	var isSeparatelyCompletedTasks: Bool { get }
	/// Определяет основание для сортировки `SortingOption`.
	var sortingOption: SortingOption { get }
}

protocol ITaskListDataSourceLayout: AnyObject {
	/// Делегат `ITaskListDataSourceLayoutDelegate`.
	var delegate: ITaskListDataSourceLayoutDelegate? { get set }
	/// Количество секций.
	var numberOfSections: Int { get }

	/// Количество задач в переданной секции.
	/// - Parameter section: Номер секции.
	/// - Returns:Количество задач.
	func numberOfTasks(in section: Int) -> Int
	/// Получение модели задачи по индексу.
	/// - Parameter index: Индекс.
	/// - Returns: При наличии задачи по переданному индексу возвращается задача `Task`, в противном случае — `nil`.
	func task(at indexPath: IndexPath) -> Task?
	/// Получение индекса задачи по модели.
	/// - Parameter task: Задача `Task`.
	/// - Returns: При обнаружении в списке переданной задачи возвращается её индекс в списке, в противном случае — `nil`.
	func indexPath(for task: Task) -> IndexPath?
}

/// Вариант сортировки задач.
enum SortingOption {
	/// Без сортировки.
	case none
	/// Сортировка по приоритету.
	case priority
}

final class TaskListDataSourceLayout: ITaskListDataSourceLayout {

	// Properties
	weak var delegate: ITaskListDataSourceLayoutDelegate?
	private let taskManager: ITaskManager
	private let taskRepository: AnyRepository<Task>

	init(taskManager: ITaskManager, taskRepository: AnyRepository<Task>) {
		self.taskManager = taskManager
		self.taskRepository = taskRepository
		prepareData()
	}

	private func prepareData() {
		taskRepository.getObjectList { [weak self] result in
			switch result {
			case .success(let tasks):
				self?.taskManager.addTasks(tasks)
			case .failure(let error):
				// Временно
				print(error.localizedDescription)
			}
		}
	}

	// MARK: - ITaskListDataLayout

	var numberOfSections: Int {
		guard let delegate = delegate else { return 1 }
		return delegate.isSeparatelyCompletedTasks ? 2 : 1
	}

	func numberOfTasks(in section: Int) -> Int {
		guard let delegate = delegate,
			  delegate.isSeparatelyCompletedTasks
		else {
			return taskManager.allTasks.count
		}
		return section == 0 ? taskManager.uncompletedTasks.count : taskManager.completedTasks.count
	}

	func task(at indexPath: IndexPath) -> Task? {
		guard let delegate = delegate,
			  delegate.isSeparatelyCompletedTasks
		else {
			let tasks = sort(tasks: taskManager.allTasks, by: delegate?.sortingOption ?? .none)
			return tasks[safe: indexPath.row]
		}
		var tasks = indexPath.section == 0 ? taskManager.uncompletedTasks : taskManager.completedTasks
		tasks = sort(tasks: tasks, by: delegate.sortingOption)
		guard indexPath.row < tasks.count else { return nil }
		return tasks[indexPath.row]
	}

	func indexPath(for task: Task) -> IndexPath? {
		guard let delegate = delegate,
			  delegate.isSeparatelyCompletedTasks
		else {
			guard let row = taskManager.allTasks.firstIndex(where: { $0 === task }) else { return nil }
			return IndexPath(row: row, section: 0)
		}
		var tasks = task.isCompleted ? taskManager.completedTasks : taskManager.uncompletedTasks
		tasks = sort(tasks: tasks, by: delegate.sortingOption)
		guard let row = tasks.firstIndex(where: { $0 === task }) else { return nil }
		return IndexPath(row: row, section: task.isCompleted ? 1 : 0)
	}

	// MARK: - Private methods

	private func sort(tasks: [Task], by option: SortingOption) -> [Task] {
		guard let delegate = delegate else { return tasks }

		switch delegate.sortingOption {
		case .none:
			return tasks
		case .priority:
			return tasks.sorted { sortingByPriority($0, and: $1) }
		}
	}

	// Обеспечивает сортировку, при которой важные задачи располагаются первее обычных (первый критерий),
	// важные с более высоким приоритетом первее важных с более низким приоритетом (второй критерий),
	// а невыполненные первее выполненных (третий критерий)
	private func sortingByPriority(_ task1: Task, and task2: Task) -> Bool {
		switch (task1, task2) {
		case (_ as ImportantTask, _ as RegularTask):
			return true
		case (_ as RegularTask, _ as ImportantTask):
			return false
		case (let task1 as ImportantTask, let task2 as ImportantTask):
			guard task1.priority != task2.priority else { return task1 > task2 }
			return task1.priority > task2.priority
		case (let task1 as RegularTask, let task2 as RegularTask):
			return task1 > task2
		default:
			return true
		}
	}
}
