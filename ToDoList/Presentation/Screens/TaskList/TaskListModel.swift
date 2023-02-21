//
//  TaskListModel.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 21.02.2023.
//

import Foundation

enum TaskListModel {

	struct ViewModel {

		struct RegularTask {
			let title: String
			let checkboxImageName: String
			let output: ITaskTableViewCellOutput
		}

		struct ImportantTask {
			let title: String
			let checkboxImageName: String
			let isExpired: Bool
			let priorityText: String
			let executionDate: String
			let output: ITaskTableViewCellOutput
		}

		enum Task {
			case regularTask(RegularTask)
			case importantTask(ImportantTask)
		}

		struct Section {
			let title: String
			let tasks: [Task]
		}

		// Properties
		let sections: [Section]
	}

	struct UpdateTaskModel {
		let oldIndexPath: IndexPath
		let newIndexPath: IndexPath
		let viewModel: ViewModel
	}
}

extension TaskListModel.ViewModel.RegularTask: Hashable {

	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.hashValue == rhs.hashValue
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(title)
		hasher.combine(checkboxImageName)
	}
}

extension TaskListModel.ViewModel.ImportantTask: Hashable {

	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.hashValue == rhs.hashValue
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(title)
		hasher.combine(checkboxImageName)
		hasher.combine(isExpired)
		hasher.combine(priorityText)
		hasher.combine(executionDate)
	}
}

extension TaskListModel.ViewModel.Task {

	var hashValue: Int {
		switch self {
		case .regularTask(let task):
			return task.hashValue
		case .importantTask(let task):
			return task.hashValue
		}
	}
}
