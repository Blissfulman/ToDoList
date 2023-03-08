//
//  TaskListModel.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 21.02.2023.
//

import Foundation

/// Модель экрана списка задач.
enum TaskListModel {

	enum FetchTaskList {
		struct Request {}
		struct Response {
			let presentationData: PresentationData
			let output: ITaskListInteractorOutput
		}
		struct ViewModel {
			let viewData: ViewData
		}
	}

	enum UpdateTask {
		struct Response {
			let presentationData: PresentationData
			let output: ITaskListInteractorOutput
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

	struct PresentationData {

		enum Section {
			case uncompleted(tasks: [Task])
			case completed(tasks: [Task])
		}

		let sections: [Section]
	}

	struct ViewData {

		struct RegularTask {
			let title: String
			let checkboxImageName: String
			let didTapCompletedCheckboxAction: () -> Void
		}

		struct ImportantTask {
			let title: String
			let checkboxImageName: String
			let isExpired: Bool
			let priorityText: String
			let executionDate: String
			let didTapCompletedCheckboxAction: () -> Void
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
