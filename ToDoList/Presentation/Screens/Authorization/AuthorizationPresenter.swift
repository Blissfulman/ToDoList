//
//  AuthorizationPresenter.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 22.02.2023.
//

import Foundation

/// Презентер экрана авторизации.
protocol IAuthorizationPresenter: AnyObject {
	/// Преподносит вью успешную авторизацию.
	func presentLogin(response: AuthorizationModel.Login.Response)
	/// Преподносит вью ошибку авторизации.
	func presentCredentialsError(response: AuthorizationModel.CredentialsError.Response)
}

private enum Constants {
	static let credentialsErrorTitle = "Credentials error"
	static let credentialsErrorMessage = "The entered credentials are invalid.\nPlease enter valid data."
	static let credentialsErrorActionTitle = "Ok"
}

/// Презентер экрана авторизации.
final class AuthorizationPresenter: IAuthorizationPresenter {

	// Properties
	weak var view: IAuthorizationView?

	// MARK: - IAuthorizationPresenter

	func presentLogin(response: AuthorizationModel.Login.Response) {
		let viewModel = AuthorizationModel.Login.ViewModel(route: .taskList)
		view?.displayLogin(viewModel: viewModel)
	}

	func presentCredentialsError(response: AuthorizationModel.CredentialsError.Response) {
		let credentialsErrorModel = AuthorizationModel.Route.CredentialsErrorModel(
			title: Constants.credentialsErrorTitle,
			message: Constants.credentialsErrorMessage,
			actionTitle: Constants.credentialsErrorActionTitle
		)
		let viewModel = AuthorizationModel.CredentialsError.ViewModel(route: .credentialsError(model: credentialsErrorModel))
		view?.displayCredentialsError(viewModel: viewModel)
	}
}
