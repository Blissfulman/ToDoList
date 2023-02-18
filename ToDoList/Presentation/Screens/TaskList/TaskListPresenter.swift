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
	private let taskListDataSourceAdaptor: ITaskListDataSourceAdaptor

	// MARK: - Init

	init(taskListDataSourceAdaptor: ITaskListDataSourceAdaptor) {
		self.taskListDataSourceAdaptor = taskListDataSourceAdaptor
	}
	
	// MARK: - ITaskListPresenter
	
	func viewDidLoad() {
		taskListDataSourceAdaptor.delegate = self
		updateViewData()
	}

	func indexPath(for task: Task) -> IndexPath? {
		taskListDataSourceAdaptor.indexPath(for: task)
	}

	func invokeUpdateViewData(shouldReloadTableData: Bool) {
		updateViewData(shouldReloadTableData: shouldReloadTableData)
	}

	// MARK: - Private methods

	private func updateViewData(shouldReloadTableData: Bool = true) {
		let tasklistViewData = TaskListViewData(
			shouldReloadTableData: shouldReloadTableData,
			numberOfSections: taskListDataSourceAdaptor.numberOfSections,
			titlesInSections: taskListDataSourceAdaptor.titlesInSections,
			numberOfTasksInSections: taskListDataSourceAdaptor.numberOfTasksInSections,
			taskModelsBySections: taskListDataSourceAdaptor.taskModelsBySections
		)
		view?.renderData(viewData: tasklistViewData)
	}
}

// MARK: - ITaskListDataSourceAdaptorDelegate

extension TaskListPresenter: ITaskListDataSourceAdaptorDelegate {

	var isSeparatelyCompletedTasks: Bool {
		true
	}
}
