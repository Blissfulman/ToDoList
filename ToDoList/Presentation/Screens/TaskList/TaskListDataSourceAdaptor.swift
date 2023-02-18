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
}

protocol ITaskListDataSourceAdaptor: AnyObject {
	/// Делегат `ITaskListDataSourceAdaptorDelegate`.
	var delegate: ITaskListDataSourceAdaptorDelegate? { get set }
	/// Количество секций.
	var numberOfSections: Int { get }
	/// Заголовки секций.
	var titlesInSections: [String] { get }
	/// Количество задач в секциях.
	var numberOfTasksInSections: [Int] { get }
	/// Модели задач. Элементы массива соответствуют секциям. Элементы вложенных массивов соответствуют задачам, расположенным в этих секциях.
	var taskModelsBySections: [[Task]] { get }
	
	/// Получение индекса задачи по модели.
	/// - Parameter task: Задача `Task`.
	/// - Returns: При обнаружении в списке переданной задачи возвращается её индекс в списке, в противном случае — `nil`.
	func indexPath(for task: Task) -> IndexPath?
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
	private let taskRepository: ITaskRepository

	private var isSeparatelyCompletedTasks: Bool {
		delegate?.isSeparatelyCompletedTasks ?? false
	}

	init(taskManager: ITaskManager, taskRepository: ITaskRepository) {
		self.taskManager = taskManager
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

	var titlesInSections: [String] {
		if isSeparatelyCompletedTasks {
			return [Constants.uncompletedTasksSectionTitle, Constants.completedTasksSectionTitle]
		} else {
			return [Constants.allTasksSectionTitle]
		}
	}

	var numberOfTasksInSections: [Int] {
		if isSeparatelyCompletedTasks {
			return [taskManager.uncompletedTasks.count, taskManager.completedTasks.count]
		} else {
			return [taskManager.allTasks.count]
		}
	}

	var taskModelsBySections: [[Task]] {
		if isSeparatelyCompletedTasks {
			return [taskManager.uncompletedTasks, taskManager.completedTasks]
		} else {
			return [taskManager.allTasks]
		}
	}

	func indexPath(for task: Task) -> IndexPath? {
		if isSeparatelyCompletedTasks {
			let tasks = task.isCompleted ? taskManager.completedTasks : taskManager.uncompletedTasks
			guard let row = tasks.firstIndex(where: { $0 === task }) else { return nil }
			return IndexPath(row: row, section: task.isCompleted ? 1 : 0)
		} else {
			guard let row = taskManager.allTasks.firstIndex(where: { $0 === task }) else { return nil }
			return IndexPath(row: row, section: 0)
		}
	}
}
