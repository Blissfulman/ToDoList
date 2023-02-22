//
//  CredentialsVerifier.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 22.02.2023.
//

import Foundation

protocol ICredentialsVerifier {
	/// Определяет валидность переданных учётных данных.
	/// - Parameter credentials: Модель учётных данных.
	/// - Returns: При успешной верификации возвращается `true`, в противном случае — `false`.
	func isValid(credentials: AuthorizationModel.Credentials) -> Bool
}

final class CredentialsVerifier: ICredentialsVerifier {

	// MARK: - ICredentialsVerifier

	func isValid(credentials: AuthorizationModel.Credentials) -> Bool {
		// Временно
		credentials.login == "Admin" && credentials.password == "pa$$32!"
	}
}
