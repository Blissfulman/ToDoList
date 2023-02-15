//
//  TaskListDataSource.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 15.02.2023.
//

import UIKit

protocol ITaskListDataSource: UITableViewDataSource {
	/// Таблица `UITableView`, протокол `UITableViewDataSource` которой реализует объект.
	var tableView: UITableView? { get set }
}

protocol ITaskTableViewCellDelegate: AnyObject {
	/// Уведомляет о переключении состояния выполнения задачи.
	/// - Parameter task: Задача, у которой происошло изменение состояния выполнения.
	func didSwitchTaskCompletedState(for task: Task)
}

private enum Constants {
	static let allTasksSectionTitle = "All tasks"
	static let completedTasksSectionTitle = "Completed tasks"
	static let uncompletedTasksSectionTitle = "Uncompleted tasks"
}

final class TaskListDataSource: NSObject, ITaskListDataSource {

	// Properties
	weak var tableView: UITableView?
	private let taskListDataSourceLayout: ITaskListDataSourceLayout

	// MARK: - Init

	init(taskListDataSourceLayout: ITaskListDataSourceLayout) {
		self.taskListDataSourceLayout = taskListDataSourceLayout
		super.init()
		prepare()
	}

	// MARK: - UITableViewDataSource

	func numberOfSections(in tableView: UITableView) -> Int {
		taskListDataSourceLayout.numberOfSections
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if isSeparatelyCompletedTasks {
			return section == 0 ? Constants.uncompletedTasksSectionTitle : Constants.completedTasksSectionTitle
		} else {
			return Constants.allTasksSectionTitle
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		taskListDataSourceLayout.numberOfTasks(in: section)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let task = taskListDataSourceLayout.task(at: indexPath) else { return UITableViewCell() }

		if let task = task as? RegularTask,
		   let cell = tableView.dequeue(type: RegularTaskTableViewCell.self, for: indexPath) {
			cell.configure(with: task)
			cell.delegate = self
			return cell
		} else if let task = task as? ImportantTask,
				  let cell = tableView.dequeue(type: ImportantTaskTableViewCell.self, for: indexPath) {
			cell.configure(with: task)
			cell.delegate = self
			return cell
		} else {
			return UITableViewCell()
		}
	}

	// MARK: - Private methods

	private func prepare() {
		taskListDataSourceLayout.delegate = self
	}
}

// MARK: - ITaskTableViewCellDelegate

extension TaskListDataSource: ITaskTableViewCellDelegate {

	func didSwitchTaskCompletedState(for task: Task) {
		tableView?.reloadData()
	}
}

extension TaskListDataSource: ITaskListDataSourceLayoutDelegate {

	var isSeparatelyCompletedTasks: Bool {
		true
	}

	var sortingOption: SortingOption {
		.priority
	}
}
