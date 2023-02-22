//
//  RegularTaskTableViewCell.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

private enum Constants {
	static let titleLabelNumberOfLines: Int = 2
	static let contentViewHeight: CGFloat = 56
	static let contentHorizontalInset: CGFloat = 16
	static let contentSpace: CGFloat = 12
	static let checkboxImageViewSize: CGFloat = 32
}

final class RegularTaskTableViewCell: UITableViewCell, IConfigurableTableCell {

	typealias ConfigurationModel = TaskListModel.ViewData.RegularTask

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

	// Properties
	private var didTapCompletedCheckboxAction: (() -> Void)?

	// MARK: - Initialization

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
	}

	// MARK: - IConfigurableTableCell

	func configure(with model: ConfigurationModel) {
		didTapCompletedCheckboxAction = model.didTapCompletedCheckboxAction
		
		titleLabel.text = model.title
		checkboxImageView.image = UIImage(systemName: model.checkboxImageName)
	}

	// MARK: - Private methods

	private func setupUI() {
		contentView.addSubview(titleLabel)
		contentView.addSubview(checkboxImageView)

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCheckbox))
		tapGestureRecognizer.isEnabled = true
		checkboxImageView.addGestureRecognizer(tapGestureRecognizer)
	}

	private func setupLayout() {
		NSLayoutConstraint.activate([
			contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.contentViewHeight),

			checkboxImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			checkboxImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentHorizontalInset),
			checkboxImageView.widthAnchor.constraint(equalToConstant: Constants.checkboxImageViewSize),
			checkboxImageView.heightAnchor.constraint(equalToConstant: Constants.checkboxImageViewSize),

			titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: checkboxImageView.trailingAnchor, constant: Constants.contentSpace),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentHorizontalInset)
		])
	}

	private func configureUI() {
		selectionStyle = .none
	}

	@objc private func didTapCheckbox() {
		didTapCompletedCheckboxAction?()
	}
}
