//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 11.02.2023.
//

import UIKit

protocol ITaskListView: AnyObject {
	/// Отображение данных на основе переданной модели.
	/// - Parameter viewModel: Модель данных вью.
	func renderData(viewModel: TaskListModel.ViewModel)
	/// Обновление задачи.
	/// - Parameter updateTaskModel: Модель для обновления задачи.
	func updateTask(updateTaskModel: TaskListModel.UpdateTaskModel)
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
	private var viewModel: TaskListModel.ViewModel = TaskListModel.ViewModel(sections: [])
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

	func renderData(viewModel: TaskListModel.ViewModel) {
		self.viewModel = viewModel
		tasksTableView.reloadData()
	}

	func updateTask(updateTaskModel: TaskListModel.UpdateTaskModel) {
		self.viewModel = updateTaskModel.viewModel
		
		tasksTableView.performBatchUpdates({
			tasksTableView.moveRow(at: updateTaskModel.oldIndexPath, to: updateTaskModel.newIndexPath)
		}, completion: { [weak self] _ in
			self?.tasksTableView.reloadRows(at: [updateTaskModel.newIndexPath], with: .automatic)
		})
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
		viewModel.sections.count
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		viewModel.sections[section].title
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.sections[section].tasks.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let task = viewModel.sections[indexPath.section].tasks[safe: indexPath.row] else { return UITableViewCell() }

		switch task {
		case .regularTask(let model):
			guard let cell = tableView.dequeue(type: RegularTaskTableViewCell.self, for: indexPath) else { return UITableViewCell() }
			cell.configure(with: model)
			return cell
		case .importantTask(let model):
			guard let cell = tableView.dequeue(type: ImportantTaskTableViewCell.self, for: indexPath) else { return UITableViewCell() }
			cell.configure(with: model)
			return cell
		}
	}
}
