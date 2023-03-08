//
//  AuthorizationModel.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 22.02.2023.
//

import Foundation

/// Модель экрана авторизации.
enum AuthorizationModel {

	// MARK: - Use cases

	/// Авторизация пользователя
	enum Login {

		struct Request {

			/// Модель введённых учётных данных пользователя.
			struct EnteredCredentials {
				let login: String?
				let password: String?
			}

			let credentials: EnteredCredentials
		}

		struct Response {

			enum RequestResult {
				case successLogin
				case missingСredentials
				case invalidСredentials
			}

			let requestResult: RequestResult
		}
	}

	// MARK: - ViewModel

	/// Модель данных вью.
	struct ViewModel {

		enum ResponseResult {
			case successLogin
			case missingСredentials(model: AlertModel)
			case invalidСredentials(model: AlertModel)
		}

		let responseResult: ResponseResult
	}
}

// MARK: - Nested models

extension AuthorizationModel {

	/// Модель учётных данных пользователя.
	struct Credentials {
		let login: String
		let password: String
	}

	/// Модель данных всплывающего сообщения.
	struct AlertModel {
		let title: String
		let message: String
		let actionTitle: String
	}
}
