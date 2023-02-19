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
	/// Получение индекса задачи по модели.
	/// - Parameter task: Задача `Task`.
	/// - Returns: При обнаружении в списке переданной задачи возвращается её индекс в списке, в противном случае — `nil`.
	func indexPath(for task: Task) -> IndexPath?
	/// Вызов обновления данных во вью.
	func invokeUpdateViewData(shouldReloadTableData: Bool)
}

final class TaskListPresenter: ITaskListPresenter {

	// Properties
	weak var view: ITaskListView?
	private let taskListSectionsAdaptor: ITaskListSectionsAdaptor
	private var sectionModels = [TaskListSectionModel]()

	// MARK: - Initialization

	init(taskListSectionsAdaptor: ITaskListSectionsAdaptor) {
		self.taskListSectionsAdaptor = taskListSectionsAdaptor
	}
	
	// MARK: - ITaskListPresenter
	
	func viewDidLoad() {
		updateViewData()
	}

	func indexPath(for task: Task) -> IndexPath? {
		var indexPath: IndexPath?
		taskListSectionsAdaptor.sectionModels.enumerated().forEach { sectionIndex, sectionModel in
			guard let rowIndex = sectionModel.taskModels.firstIndex(where: { task === $0 }) else { return }
			indexPath = IndexPath(row: rowIndex, section: sectionIndex)
		}
		return indexPath
	}

	func invokeUpdateViewData(shouldReloadTableData: Bool) {
		updateViewData(shouldReloadTableData: shouldReloadTableData)
	}

	// MARK: - Private methods

	private func updateViewData(shouldReloadTableData: Bool = true) {
		sectionModels = taskListSectionsAdaptor.sectionModels

		let tasklistViewData = TaskListViewData(
			shouldReloadTableData: shouldReloadTableData,
			sectionModels: sectionModels
		)
		view?.renderData(viewData: tasklistViewData)
	}
}
