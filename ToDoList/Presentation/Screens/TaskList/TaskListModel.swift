//
//  TaskListModel.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 21.02.2023.
//

import Foundation

enum TaskListModel {

	enum FetchTaskList {
		struct Request {}
		struct Response {
			let presentationData: PresentationData
			let output: ITaskTableViewCellOutput
		}
		struct ViewModel {
			let viewData: ViewData
		}
	}

	enum UpdateTask {
		struct Response {
			let presentationData: PresentationData
			let output: ITaskTableViewCellOutput
			let oldIndexPath: IndexPath
			let newIndexPath: IndexPath
		}
		struct ViewModel {
			let viewData: ViewData
			let oldIndexPath: IndexPath
			let newIndexPath: IndexPath
		}
	}
}

// MARK: - Nested models

extension TaskListModel {

	typealias RawTask = Task

	struct PresentationData {

		enum Section {
			case uncompleted(tasks: [RawTask])
			case completed(tasks: [RawTask])
		}

		let sections: [Section]
	}

	struct ViewData {

		struct RegularTask {
			let title: String
			let checkboxImageName: String
			let rawTask: RawTask
			let output: ITaskTableViewCellOutput
		}

		struct ImportantTask {
			let title: String
			let checkboxImageName: String
			let isExpired: Bool
			let priorityText: String
			let executionDate: String
			let rawTask: RawTask
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

		let sections: [Section]
	}
}
