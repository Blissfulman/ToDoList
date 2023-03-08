//
//  AuthorizationInteractor.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 22.02.2023.
//

import Foundation

/// Интерактор экрана авторизации.
protocol IAuthorizationInteractor: AnyObject {
	/// Запрашивает авторизацию.
	func requestLogin(request: AuthorizationModel.Login.Request)
}

/// Интерактор экрана авторизации.
final class AuthorizationInteractor: IAuthorizationInteractor {

	// Properties
	private let presenter: IAuthorizationPresenter
	private let credentialsVerifier: ICredentialsVerifier

	// MARK: - Initialization

	init(presenter: IAuthorizationPresenter, credentialsVerifier: ICredentialsVerifier) {
		self.presenter = presenter
		self.credentialsVerifier = credentialsVerifier
	}

	// MARK: - AuthorizationInteractor

	func requestLogin(request: AuthorizationModel.Login.Request) {
		guard let login = request.credentials.login,
			  let password = request.credentials.password,
			  !login.isEmpty,
			  !password.isEmpty
		else {
			let response = AuthorizationModel.Login.Response(requestResult: .missingСredentials)
			presenter.presentLogin(response: response)
			return
		}
		
		let isValidCredentials = credentialsVerifier.isValid(credentials: AuthorizationModel.Credentials(login: login, password: password))
		let response = AuthorizationModel.Login.Response(requestResult: isValidCredentials ? .successLogin : .invalidСredentials)
		presenter.presentLogin(response: response)
	}
}
