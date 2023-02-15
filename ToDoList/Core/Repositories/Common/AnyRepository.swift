//
//  AnyRepository.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 15.02.2023.
//

import Foundation

final class AnyRepository<Object>: IRepository {

	// Properties
	private let getObjectListAction: (_ completion: @escaping (Result<[Object], Error>) -> Void) -> Void

	// MARK: - Init

	init<Repository: IRepository>(_ repository: Repository) where Repository.Object == Object {
		self.getObjectListAction = repository.getObjectList
	}

	// MARK: - IRepository

	func getObjectList(completion: @escaping (Result<[Object], Error>) -> Void) {
		getObjectListAction(completion)
	}
}
