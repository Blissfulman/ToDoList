//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 11.02.2023.
//

import UIKit

protocol ITaskListView: AnyObject {
	/// Обновление данных в списке.
	func reloadData()
}

protocol ITaskTableViewCellDelegate: AnyObject {
	func didSwitchTaskCompletion(for task: Task)
}

final class TaskListViewController: UIViewController {

	// UI
	private lazy var tasksTableView: UITableView = {
		let tableView = UITableView().prepareForAutoLayout()
		tableView.registerCell(type: RegularTaskTableViewCell.self)
		tableView.registerCell(type: ImportantTaskTableViewCell.self)
		tableView.dataSource = self
		return tableView
	}()

	// Properties
	private let presenter: ITaskListPresenter
	
	// MARK: - Init

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
		title = "To Do List"
	}
}

extension TaskListViewController: ITaskListView {
	func reloadData() {
		tasksTableView.reloadData()
	}
}

extension TaskListViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.taskCount
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let task = presenter.task(at: indexPath.row) else { return UITableViewCell() }

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

	func didSwitchTaskCompletion(for task: Task) {
		guard let index = presenter.index(for: task) else { return }
		tasksTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
	}
}
