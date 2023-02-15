//
//  ImportantTaskTableViewCell.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

private enum Constants {
	static let titleLabelNumberOfLines: Int = 2
	static let completedCheckboxImageName = "checkmark.circle.fill"
	static let uncompletedCheckboxImageName = "circle"
	static let expiredTaskBackgroundColor: UIColor = .red.withAlphaComponent(0.2)
	static let unexpiredTaskBackgroundColor: UIColor = .white
	static let priorityLabelText = "Priority: "
	static let contentVerticalInset: CGFloat = 12
	static let contentHorizontalInset: CGFloat = 16
	static let contentSpace: CGFloat = 12
	static let checkboxImageViewSize: CGFloat = 32
}

private extension ImportantTask.Priority {

	var description: String {
		switch self {
		case .low:
			return "low"
		case .medium:
			return "medium"
		case .high:
			return "high"
		}
	}
}

final class ImportantTaskTableViewCell: UITableViewCell, IConfigurableTableCell {

	typealias ConfigurationModel = ImportantTask

	// UI
	private lazy var checkboxImageView: UIImageView = {
		let imageView = UIImageView().prepareForAutoLayout()
		imageView.isUserInteractionEnabled = true
		return imageView
	}()
	private lazy var titleLabel: UILabel = {
		let label = UILabel().prepareForAutoLayout()
		label.numberOfLines = Constants.titleLabelNumberOfLines
		return label
	}()
	private lazy var priorityLabel: UILabel = {
		let label = UILabel().prepareForAutoLayout()
		label.textColor = .darkGray
		return label
	}()
	private lazy var executionDateLabel: UILabel = {
		let label = UILabel().prepareForAutoLayout()
		label.textColor = .darkGray
		return label
	}()

	// Properties
	private var task: ConfigurationModel?
	weak var delegate: ITaskTableViewCellDelegate?

	// MARK: - Init

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
		setupLayout()
		configureUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func prepareForReuse() {
		super.prepareForReuse()
		checkboxImageView.image = nil
		titleLabel.text = nil
		executionDateLabel.text = nil
		priorityLabel.text = nil
		executionDateLabel.text = nil
	}

	// MARK: - IConfigurableTableCell

	func configure(with model: ConfigurationModel) {
		task = model
		titleLabel.text = model.title
		checkboxImageView.image = UIImage(systemName: model.isCompleted ? Constants.completedCheckboxImageName : Constants.uncompletedCheckboxImageName)
		contentView.backgroundColor = model.isExpired ? Constants.expiredTaskBackgroundColor : Constants.unexpiredTaskBackgroundColor
		priorityLabel.text = Constants.priorityLabelText + model.priority.description
		executionDateLabel.text = model.executionDate?.formatted(date: .numeric, time: .omitted)
	}

	// MARK: - Private methods

	private func setupUI() {
		contentView.addSubview(titleLabel)
		contentView.addSubview(checkboxImageView)
		contentView.addSubview(priorityLabel)
		contentView.addSubview(executionDateLabel)

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCheckbox))
		tapGestureRecognizer.isEnabled = true
		checkboxImageView.addGestureRecognizer(tapGestureRecognizer)
	}

	private func setupLayout() {
		NSLayoutConstraint.activate([
			checkboxImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			checkboxImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentHorizontalInset),
			checkboxImageView.widthAnchor.constraint(equalToConstant: Constants.checkboxImageViewSize),
			checkboxImageView.heightAnchor.constraint(equalToConstant: Constants.checkboxImageViewSize),

			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.contentVerticalInset),
			titleLabel.leadingAnchor.constraint(equalTo: checkboxImageView.trailingAnchor, constant: Constants.contentSpace),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentHorizontalInset),

			priorityLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.contentSpace),
			priorityLabel.leadingAnchor.constraint(equalTo: checkboxImageView.trailingAnchor, constant: Constants.contentSpace),
			priorityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.contentVerticalInset),

			executionDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.contentSpace),
			executionDateLabel.leadingAnchor.constraint(equalTo: priorityLabel.trailingAnchor, constant: Constants.contentSpace),
			executionDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentHorizontalInset),
			executionDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.contentVerticalInset),
		])
		executionDateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
	}

	private func configureUI() {
		selectionStyle = .none
	}

	@objc private func didTapCheckbox() {
		if let task = task {
			task.isCompleted = !task.isCompleted
			delegate?.didSwitchTaskCompletedState(for: task)
		}
	}
}
