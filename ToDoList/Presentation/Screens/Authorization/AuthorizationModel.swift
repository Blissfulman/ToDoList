//
//  AuthorizationModel.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 22.02.2023.
//

import Foundation

/// Модель экрана авторизации.
enum AuthorizationModel {

	enum Login {
		struct Request {
			let credentials: Credentials
		}
		struct Response {}
		struct ViewModel {
			let route: Route
		}
	}

	enum CredentialsError {
		struct Response {}
		struct ViewModel {
			let route: Route
		}
	}

	// MARK: - Routing

	enum Route {

		struct CredentialsErrorModel {
			let title: String
			let message: String
			let actionTitle: String
		}

		case taskList
		case credentialsError(model: CredentialsErrorModel)
	}
}

extension AuthorizationModel {

	struct Credentials {
		let login: String?
		let password: String?
	}
}
