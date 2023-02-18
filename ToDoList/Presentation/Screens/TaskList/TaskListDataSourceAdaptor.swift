//
//  TaskListDataSourceAdaptor.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 15.02.2023.
//

import Foundation

/// Протокол адаптера, делегирующий способ представления задач. Предоставляет интерфейс для выбора способа представления данных.
protocol ITaskListDataSourceAdaptorDelegate: AnyObject {
	/// Определяет необходимость разделения завершённых и незавершённых задач в разные секции.
	var isSeparatelyCompletedTasks: Bool { get }
	/// Определяет основание для сортировки `SortingOption`.
	var sortingOption: SortingOption { get }
}

protocol ITaskListDataSourceAdaptor: AnyObject {
	/// Делегат `ITaskListDataSourceAdaptorDelegate`.
	var delegate: ITaskListDataSourceAdaptorDelegate? { get set }
	/// Количество секций.
	var numberOfSections: Int { get }
	/// Заголовки секций. Ключ словаря — номер секции, значение — заголовок.
	var titlesInSections: [Int: String] { get }
	/// Количество задач в секциях. Ключ словаря — номер секции, значение — количество задач.
	var numberOfTasksInSections: [Int: Int] { get }
	/// Модели задач, соответствующие IndexPath-ам ячеек таблицы. Ключ словаря — IndexPath ячейки, значение — модель задачи.
	var taskModelsByIndexPaths: [IndexPath: Task] { get }
	
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

private enum Constants {
	static let allTasksSectionTitle = "All tasks"
	static let completedTasksSectionTitle = "Completed tasks"
	static let uncompletedTasksSectionTitle = "Uncompleted tasks"
}

final class TaskListDataSourceAdaptor: ITaskListDataSourceAdaptor {

	// Properties
	weak var delegate: ITaskListDataSourceAdaptorDelegate?
	private let taskManager: ITaskManager
	private let prioritySortedTaskManagerDecorator: ITaskManager
	private let taskRepository: ITaskRepository

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
		taskRepository: ITaskRepository
	) {
		self.taskManager = taskManager
		self.prioritySortedTaskManagerDecorator = prioritySortedTaskManagerDecorator
		self.taskRepository = taskRepository
		prepareData()
	}

	private func prepareData() {
		taskRepository.getTaskList { [weak self] result in
			switch result {
			case .success(let taskList):
				self?.taskManager.addTasks(taskList)
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

	var titlesInSections: [Int: String] {
		if isSeparatelyCompletedTasks {
			return [0: Constants.uncompletedTasksSectionTitle, 1: Constants.completedTasksSectionTitle]
		} else {
			return [0: Constants.allTasksSectionTitle]
		}
	}

	var numberOfTasksInSections: [Int: Int] {
		if isSeparatelyCompletedTasks {
			return [0: uncompletedTasks.count, 1: completedTasks.count]
		} else {
			return [0: allTasks.count]
		}
	}

	var taskModelsByIndexPaths: [IndexPath: Task] {
		if isSeparatelyCompletedTasks {
			var result = [IndexPath: Task]()
			uncompletedTasks.enumerated().forEach { result[IndexPath(row: $0, section: 0)] = $1 }
			completedTasks.enumerated().forEach { result[IndexPath(row: $0, section: 1)] = $1 }
			return result
		} else {
			var result = [IndexPath: Task]()
			allTasks.enumerated().forEach { result[IndexPath(row: $0, section: 0)] = $1 }
			return result
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
