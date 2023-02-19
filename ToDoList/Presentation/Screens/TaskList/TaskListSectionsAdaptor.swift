//
//  TaskListSectionsAdaptor.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 19.02.2023.
//

import Foundation

/// Адаптер, предоставляющий данные о списке задач в виде списка моделей секций.
protocol ITaskListSectionsAdaptor: AnyObject {
	/// Список моделей секций.
	var sectionModels: [TaskListSectionModel] { get }
}

/// Модель секции списка задач.
struct TaskListSectionModel {
	/// Заголовок.
	let title: String
	/// Модели задач.
	let taskModels: [Task]
}

/// Секции списка задач.
enum TaskListSection: CaseIterable {
	case uncompletedTasks
	case completedTasks
}

private enum Constants {
	static let completedTasksSectionTitle = "Completed tasks"
	static let uncompletedTasksSectionTitle = "Uncompleted tasks"
}

final class TaskListSectionsAdaptor: ITaskListSectionsAdaptor {

	// Properties
	private let taskManager: ITaskManager
	private let taskRepository: ITaskRepository

	// MARK: - Init

	init(taskManager: ITaskManager, taskRepository: ITaskRepository) {
		self.taskManager = taskManager
		self.taskRepository = taskRepository
		prepareData()
	}

	// MARK: - ITaskListSectionsAdaptor

	var sectionModels: [TaskListSectionModel] {
		var sections = [TaskListSectionModel]()
		TaskListSection.allCases.forEach { sections.append(sectionModel(for: $0)) }
		return sections
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

	func sectionModel(for section: TaskListSection) -> TaskListSectionModel {
		switch section {
		case .uncompletedTasks:
			return TaskListSectionModel(title: Constants.uncompletedTasksSectionTitle, taskModels: taskManager.uncompletedTasks)
		case .completedTasks:
			return TaskListSectionModel(title: Constants.completedTasksSectionTitle, taskModels: taskManager.completedTasks)
		}
	}
}
