//
//  TaskListSectionsAdapter.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 19.02.2023.
//

import Foundation

/// Адаптер, предоставляющий данные о списке задач в виде списка моделей секций.
protocol ITaskListSectionsAdapter: AnyObject {
	/// Возвращает список моделей секций.
	/// - Parameter output: Объект `ITaskTableViewCellOutput`.
	/// - Returns: Список моделей секций.
	func sectionModels(output: ITaskTableViewCellOutput) -> [TaskListModel.ViewModel.Section]
	/// Возвращает задачу по переданному IndexPath.
	/// - Parameter indexPath: `IndexPath` задачи.
	/// - Returns: При нахождении задачи по переданному IndexPath возвращается задача `Task`, в противном случае — `nil`.
	func task(at indexPath: IndexPath) -> Task?
	/// Возвращает IndexPath для переданной задачи.
	/// - Parameter task: Задача.
	/// - Returns: При нахождении задачи возвращается её `IndexPath`, в противном случае — `nil`.
	func indexPath(for task: Task) -> IndexPath?
}

private extension ImportantTask.Priority {

	var description: String {
		switch self {
		case .low:
			return "low"
		case .medium:
			return "medium"
		case .high:
			return "high"
		}
	}
}

private enum Constants {
	static let completedTasksSectionTitle = "Completed tasks"
	static let uncompletedTasksSectionTitle = "Uncompleted tasks"
	static let completedCheckboxImageName = "checkmark.circle.fill"
	static let uncompletedCheckboxImageName = "circle"
	static let priorityLabelText = "Priority: "
}

final class TaskListSectionsAdapter: ITaskListSectionsAdapter {

	// Properties
	private let taskManager: ITaskManager
	private let taskRepository: ITaskRepository

	// MARK: - Initialization

	init(taskManager: ITaskManager, taskRepository: ITaskRepository) {
		self.taskManager = taskManager
		self.taskRepository = taskRepository
		prepareData()
	}

	// MARK: - ITaskListSectionsAdapter

	func sectionModels(output: ITaskTableViewCellOutput) -> [TaskListModel.ViewModel.Section] {
		[
			mapToSectionModelTasks(
				taskManager.uncompletedTasks,
				withTitle: Constants.uncompletedTasksSectionTitle,
				output: output
			),
			mapToSectionModelTasks(
				taskManager.completedTasks,
				withTitle: Constants.completedTasksSectionTitle,
				output: output
			)
		]
	}

	func task(at indexPath: IndexPath) -> Task? {
		switch indexPath.section {
		case 0:
			return taskManager.uncompletedTasks[safe: indexPath.row]
		case 1:
			return taskManager.completedTasks[safe: indexPath.row]
		default:
			return nil
		}
	}

	func indexPath(for task: Task) -> IndexPath? {
		let tasks = task.isCompleted ? taskManager.completedTasks : taskManager.uncompletedTasks
		guard let row = tasks.firstIndex(where: { task === $0 }) else { return nil }
		return IndexPath(row: row, section: task.isCompleted ? 1 : 0)
	}

	// MARK: - Private methods

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

	private func mapToSectionModelTasks(_ tasks: [Task], withTitle title: String, output: ITaskTableViewCellOutput) -> TaskListModel.ViewModel.Section {
		let tasks = tasks.map { mapTask($0, output: output) }
		let viewModel = TaskListModel.ViewModel.Section(title: title, tasks: tasks)
		return viewModel
	}

	private func mapTask(_ task: Task, output: ITaskTableViewCellOutput) -> TaskListModel.ViewModel.Task {
		switch task {
		case let importantTask as ImportantTask:
			let task = TaskListModel.ViewModel.ImportantTask(
				title: importantTask.title,
				checkboxImageName: importantTask.isCompleted ? Constants.completedCheckboxImageName : Constants.uncompletedCheckboxImageName,
				isExpired: importantTask.isExpired,
				priorityText: Constants.priorityLabelText + importantTask.priority.description,
				executionDate: importantTask.executionDate?.formatted(date: .numeric, time: .omitted) ?? "No executionDate",
				output: output
			)
			return .importantTask(task)
		case let task:
			let task = TaskListModel.ViewModel.RegularTask(
				title: task.title,
				checkboxImageName: task.isCompleted ? Constants.completedCheckboxImageName : Constants.uncompletedCheckboxImageName,
				output: output
			)
			return .regularTask(task)
		}
	}
}
