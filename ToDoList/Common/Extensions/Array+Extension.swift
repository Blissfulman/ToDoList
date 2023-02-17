//
//  Array+Extension.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 15.02.2023.
//

import Foundation

extension Array {

	subscript(safe index: Int) -> Element? {
		get {
			guard indices.contains(index) else { return nil }
			return self[index]
		}
		set {
			if let newValue = newValue,
			   indices.contains(index) {
				self[index] = newValue
			}
		}
	}
}
