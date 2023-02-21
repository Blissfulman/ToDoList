//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 18.02.2023.
//

import Foundation

protocol ITaskListPresenter: AnyObject {
	/// Вью загружено.
	func viewDidLoad()
}

protocol ITaskTableViewCellOutput: AnyObject {
	/// Уведомляет о изменении состояния выполненности задачи.
	/// - Parameter model: Модель задачи, у которой произошло изменение состояния выполненности.
	func taskCompletionStateDidChange(for model: AnyHashable)
}

final class TaskListPresenter: ITaskListPresenter {

	// Properties
	weak var view: ITaskListView?
	private let taskListSectionsAdapter: ITaskListSectionsAdapter
	private var sectionModels = [TaskListModel.ViewModel.Section]()

	// MARK: - Initialization

	init(taskListSectionsAdapter: ITaskListSectionsAdapter) {
		self.taskListSectionsAdapter = taskListSectionsAdapter
	}
	
	// MARK: - ITaskListPresenter
	
	func viewDidLoad() {
		updateViewData()
	}

	// MARK: - Private methods

	private func updateViewData() {
		sectionModels = taskListSectionsAdapter.sectionModels(output: self)
		view?.renderData(viewModel: TaskListModel.ViewModel(sections: sectionModels))
	}

	private func indexPath(for model: AnyHashable) -> IndexPath? {
		var indexPath: IndexPath?
		sectionModels.enumerated().forEach { sectionIndex, sectionModel in
			guard let rowIndex = sectionModel.tasks.firstIndex(where: { model.hashValue == $0.hashValue }) else { return }
			indexPath = IndexPath(row: rowIndex, section: sectionIndex)
		}
		return indexPath
	}
}

// MARK: - ITaskTableViewCellOutput

extension TaskListPresenter: ITaskTableViewCellOutput {
	
	func taskCompletionStateDidChange(for model: AnyHashable) {
		guard let oldIndexPath = indexPath(for: model),
			  let task = taskListSectionsAdapter.task(at: oldIndexPath)
		else { return }
		task.isCompleted.toggle()
		guard let newIndexPath = taskListSectionsAdapter.indexPath(for: task) else { return }

		sectionModels = taskListSectionsAdapter.sectionModels(output: self)
		let updateTaskModel = TaskListModel.UpdateTaskModel(
			oldIndexPath: oldIndexPath,
			newIndexPath: newIndexPath,
			viewModel: TaskListModel.ViewModel(sections: sectionModels)
		)
		view?.updateTask(updateTaskModel: updateTaskModel)
	}
}
