//
//  AuthorizationRouter.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 22.02.2023.
//

import UIKit

protocol IAuthorizationRouter {
	/// Переходит по указанному направлению.
	/// - Parameter route: Направление перехода.
	func navigateTo(route: AuthorizationModel.Route)
}

final class AuthorizationRouter: IAuthorizationRouter {

	// Properties
	weak var viewController: UIViewController?

	// MARK: - IAuthorizationRouter

	func navigateTo(route: AuthorizationModel.Route) {
		switch route {
		case .taskList:
			navigateToTaskList()
		case .credentialsError(let model):
			navigateCredentialsError(model: model)
		}
	}

	// MARK: - Private methods

	private func navigateToTaskList() {
		let taskListViewController = TaskListAssembly().assemble()
		taskListViewController.navigationItem.hidesBackButton = true
		viewController?.show(taskListViewController, sender: self)
	}

	private func navigateCredentialsError(model: AuthorizationModel.Route.CredentialsErrorModel) {
		let credentialsErrorAlertController = UIAlertController(
			title: model.title,
			message: model.message,
			preferredStyle: .alert
		)
		let alertAction = UIAlertAction(title: model.actionTitle, style: .default)
		credentialsErrorAlertController.addAction(alertAction)
		viewController?.present(credentialsErrorAlertController, animated: true)
	}
}
