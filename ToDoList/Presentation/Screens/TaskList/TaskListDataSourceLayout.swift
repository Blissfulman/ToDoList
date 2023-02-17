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
	private let prioritySortedTaskManagerDecorator: ITaskManager
	private let taskRepository: AnyRepository<Task>

	private var isSeparatelyCompletedTasks: Bool {
		delegate?.isSeparatelyCompletedTasks ?? false
	}
	private var sortingOption: SortingOption {
		delegate?.sortingOption ?? .none
	}
	private var allTasks: [Task] {
		sortingOption == .priority ? prioritySortedTaskManagerDecorator.allTasks : taskManager.allTasks
	}
	private var completedTasks: [Task] {
		sortingOption == .priority ? prioritySortedTaskManagerDecorator.completedTasks : taskManager.completedTasks
	}
	private var uncompletedTasks: [Task] {
		sortingOption == .priority ? prioritySortedTaskManagerDecorator.uncompletedTasks : taskManager.uncompletedTasks
	}

	init(
		taskManager: ITaskManager,
		prioritySortedTaskManagerDecorator: ITaskManager,
		taskRepository: AnyRepository<Task>
	) {
		self.taskManager = taskManager
		self.prioritySortedTaskManagerDecorator = prioritySortedTaskManagerDecorator
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
		isSeparatelyCompletedTasks ? 2 : 1
	}

	func numberOfTasks(in section: Int) -> Int {
		if isSeparatelyCompletedTasks {
			return section == 0 ? uncompletedTasks.count : completedTasks.count
		} else {
			return allTasks.count
		}
	}

	func task(at indexPath: IndexPath) -> Task? {
		if isSeparatelyCompletedTasks {
			let tasks = indexPath.section == 0 ? uncompletedTasks : completedTasks
			return tasks[safe: indexPath.row]
		} else {
			return allTasks[safe: indexPath.row]
		}
	}

	func indexPath(for task: Task) -> IndexPath? {
		if isSeparatelyCompletedTasks {
			let tasks = task.isCompleted ? completedTasks : uncompletedTasks
			guard let row = tasks.firstIndex(where: { $0 === task }) else { return nil }
			return IndexPath(row: row, section: task.isCompleted ? 1 : 0)
		} else {
			guard let row = allTasks.firstIndex(where: { $0 === task }) else { return nil }
			return IndexPath(row: row, section: 0)
		}
	}
}
