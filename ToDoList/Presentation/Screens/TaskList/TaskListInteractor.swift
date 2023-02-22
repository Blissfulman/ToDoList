//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 18.02.2023.
//

import Foundation

protocol ITaskListInteractor: AnyObject {
	/// Запрашивает список задач.
	func requestTaskList(request: TaskListModel.FetchTaskList.Request)
}

protocol ITaskTableViewCellOutput: AnyObject {
	/// Уведомляет о изменении состояния выполненности задачи.
	/// - Parameter task: Задача, у которой произошло изменение состояния выполненности.
	func didTapCompletedCheckbox(for task: Task)
}

final class TaskListInteractor: ITaskListInteractor {

	// Properties
	private let presenter: ITaskListPresenter
	private let taskRepository: ITaskRepository
	private let taskListDataAdapter: ITaskListDataAdapter

	// MARK: - Initialization

	init(
		presenter: ITaskListPresenter,
		taskRepository: ITaskRepository,
		taskListDataAdapter: ITaskListDataAdapter
	) {
		self.presenter = presenter
		self.taskRepository = taskRepository
		self.taskListDataAdapter = taskListDataAdapter
	}
	
	// MARK: - ITaskListPresenter
	
	func requestTaskList(request: TaskListModel.FetchTaskList.Request) {
		taskRepository.getTaskList { [weak self] result in
			guard let self = self else { return }

			switch result {
			case .success(let tasks):
				self.taskListDataAdapter.loadToManager(tasks)

				let response = TaskListModel.FetchTaskList.Response(
					presentationData: self.taskListDataAdapter.presentationData,
					output: self
				)
				self.presenter.presentTaskList(response: response)
			case .failure(let error):
				// Временно
				print(error.localizedDescription)
			}
		}
	}
}

// MARK: - ITaskTableViewCellOutput

extension TaskListInteractor: ITaskTableViewCellOutput {

	func didTapCompletedCheckbox(for task: Task) {
		guard let oldIndexPath = taskListDataAdapter.indexPath(for: task) else { return }
		task.isCompleted.toggle()
		guard let newIndexPath = taskListDataAdapter.indexPath(for: task) else { return }
		
		let response = TaskListModel.UpdateTask.Response(
			presentationData: taskListDataAdapter.presentationData,
			output: self,
			oldIndexPath: oldIndexPath,
			newIndexPath: newIndexPath
		)
		presenter.presentUpdatedTask(response: response)
	}
}
