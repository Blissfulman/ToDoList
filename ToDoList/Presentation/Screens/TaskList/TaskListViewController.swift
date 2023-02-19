//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 11.02.2023.
//

import UIKit

protocol ITaskListView: AnyObject {
	/// Отображение данных на основе переданной модели.
	/// - Parameter viewData: Модель данных вью.
	func renderData(viewData: TaskListViewData)
}

protocol ITaskTableViewCellDelegate: AnyObject {
	/// Уведомляет о переключении состояния выполненности задачи.
	/// - Parameter task: Задача, у которой произошло изменение состояния выполненности.
	func didSwitchTaskCompletionState(for task: Task)
}

struct TaskListViewData {
	/// Следует ли производить перезагрузку данных таблицы.
	let shouldReloadTableData: Bool
	/// Список моделей секций.
	var sectionModels: [TaskListSectionModel]
}

private enum Constants {
	static let title = "To Do List"
}

final class TaskListViewController: UIViewController, ITaskListView {

	// UI
	private lazy var tasksTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped).prepareForAutoLayout()
		tableView.registerCell(type: RegularTaskTableViewCell.self)
		tableView.registerCell(type: ImportantTaskTableViewCell.self)
		tableView.dataSource = self
		return tableView
	}()

	// Properties
	private var viewData: TaskListViewData?
	private let presenter: ITaskListPresenter
	
	// MARK: - Initialization

	init(presenter: ITaskListPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupLayout()
		configureUI()
		presenter.viewDidLoad()
	}

	// MARK: - ITaskListView

	func renderData(viewData: TaskListViewData) {
		self.viewData = viewData
		if viewData.shouldReloadTableData {
			tasksTableView.reloadData()
		}
	}

	// MARK: - Private methods

	private func setupUI() {
		view.addSubview(tasksTableView)
	}

	private func setupLayout() {
		NSLayoutConstraint.activate([
			tasksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	private func configureUI() {
		view.backgroundColor = .white
		title = Constants.title
	}
}

// MARK: - UITableViewDataSource

extension TaskListViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		viewData?.sectionModels.count ?? 0
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		viewData?.sectionModels[safe: section]?.title
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewData?.sectionModels[safe: section]?.taskModels.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let task = viewData?.sectionModels[safe: indexPath.section]?.taskModels[safe: indexPath.row] else { return UITableViewCell() }

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
}

// MARK: - ITaskTableViewCellDelegate

extension TaskListViewController: ITaskTableViewCellDelegate {

	func didSwitchTaskCompletionState(for task: Task) {
		guard let cellIndexBeforeUpdating = presenter.indexPath(for: task) else {
			tasksTableView.reloadData()
			return
		}
		task.isCompleted.toggle()
		guard let cellIndexAfterUpdating = presenter.indexPath(for: task) else {
			tasksTableView.reloadData()
			return
		}
		presenter.invokeUpdateViewData(shouldReloadTableData: false)
		tasksTableView.performBatchUpdates({
			tasksTableView.moveRow(at: cellIndexBeforeUpdating, to: cellIndexAfterUpdating)
		}, completion: { [weak self] _ in
			self?.tasksTableView.reloadRows(at: [cellIndexAfterUpdating], with: .automatic)
		})
	}
}
