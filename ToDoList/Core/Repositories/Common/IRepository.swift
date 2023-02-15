//
//  ITaskRepository.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 15.02.2023.
//

import Foundation

protocol IRepository {
	associatedtype Object

	/// Получение списка объектов.
	/// - Parameter completion: Обработчик завершения, в который возращается результат (массив объектов, либо ошибка `Error`).
	func getObjectList(completion: @escaping (Result<[Object], Error>) -> Void)
}

extension IRepository {

	/// Получение репозитория со стёртым типом.
	/// - Returns: Объект репозитория `AnyRepository`.
	func eraseToAnyRepository() -> AnyRepository<Object> {
		AnyRepository(self)
	}
}
