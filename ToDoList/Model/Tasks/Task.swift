//
//  Task.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 11.02.2023.
//

import Foundation

class Task {

	// Properties
	var title: String
	var isCompleted = false

	// MARK: - Init

	init(title: String) {
		self.title = title
	}
}

// MARK: - Comparable

extension Task: Comparable {

	static func == (lhs: Task, rhs: Task) -> Bool {
		lhs === rhs
	}

	static func < (lhs: Task, rhs: Task) -> Bool {
		lhs.isCompleted == true && rhs.isCompleted == false
	}
}
