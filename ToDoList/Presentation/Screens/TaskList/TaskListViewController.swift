//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 11.02.2023.
//

import UIKit

private enum Constants {
	static let title = "To Do List"
}

final class TaskListViewController: UIViewController {

	// UI
	private lazy var tasksTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped).prepareForAutoLayout()
		tableView.registerCell(type: RegularTaskTableViewCell.self)
		tableView.registerCell(type: ImportantTaskTableViewCell.self)
		tableView.dataSource = taskListDataSource
		return tableView
	}()

	// Properties
	private let taskListDataSource: ITaskListDataSource
	
	// MARK: - Init

	init(taskListDataSource: ITaskListDataSource) {
		self.taskListDataSource = taskListDataSource
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
		taskListDataSource.tableView = tasksTableView
		tasksTableView.reloadData()
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
