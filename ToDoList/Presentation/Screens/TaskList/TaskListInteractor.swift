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
	/// - Parameter task: Модель задачи, у которой произошло изменение состояния выполненности.
	func didTapCompletedCheckbox(for task: TaskListModel.RawTask)
}

final class TaskListInteractor: ITaskListInteractor {

	// Properties
	private let presenter: ITaskListPresenter
	private let taskRepository: ITaskRepository
	private let taskListSectionsAdapter: ITaskListSectionsAdapter

	// MARK: - Initialization

	init(presenter: ITaskListPresenter,
		 taskRepository: ITaskRepository,
		 taskListSectionsAdapter: ITaskListSectionsAdapter
	) {
		self.presenter = presenter
		self.taskRepository = taskRepository
		self.taskListSectionsAdapter = taskListSectionsAdapter
	}
	
	// MARK: - ITaskListPresenter
	
	func requestTaskList(request: TaskListModel.FetchTaskList.Request) {
		taskRepository.getTaskList { [weak self] result in
			guard let self = self else { return }

			switch result {
			case .success(let tasks):
				self.taskListSectionsAdapter.loadToManager(tasks)

				let response = TaskListModel.FetchTaskList.Response(
					presentationData: self.taskListSectionsAdapter.presentationData,
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

	func didTapCompletedCheckbox(for task: TaskListModel.RawTask) {
		guard let oldIndexPath = taskListSectionsAdapter.indexPath(for: task) else { return }
		task.isCompleted.toggle()
		guard let newIndexPath = taskListSectionsAdapter.indexPath(for: task) else { return }
		
		let response = TaskListModel.UpdateTask.Response(
			presentationData: taskListSectionsAdapter.presentationData,
			output: self,
			oldIndexPath: oldIndexPath,
			newIndexPath: newIndexPath
		)
		presenter.presentUpdatedTask(response: response)
	}
}
