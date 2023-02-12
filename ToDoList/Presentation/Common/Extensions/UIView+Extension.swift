//
//  UIView+Extension.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

extension UIView {

	@discardableResult
	func prepareForAutoLayout() -> Self {
		translatesAutoresizingMaskIntoConstraints = false
		return self
	}
}
