//
//  UserProfileHeaderView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import UIKit

final class UserProfileHeaderView: UIView {
    private let titleLabel = UILabel()
    private let editButton = UIButton(type: .system)
    private let avatarBorderView = UIView()
    private let avatarView = UserProfileRemoteImageView()
    private let nameLabel = UILabel()
    private let emailContainerView = UIView()
    private let emailIconView = UIImageView()
    private let emailLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configureAppearance()
    }

    func configure(content: UserProfileContent, imageLoader: ImageLoader) {
        nameLabel.text = content.fullName.replacingOccurrences(of: " ", with: "\n")
        emailLabel.text = content.email
        avatarView.setImage(urlString: content.avatarURLString, imageLoader: imageLoader)
    }

    func addEditTarget(_ target: Any?, action: Selector) {
        editButton.addTarget(target, action: action, for: .touchUpInside)
    }

    private func setupHierarchy() {
        [
            titleLabel,
            editButton,
            avatarBorderView,
            nameLabel,
            emailContainerView
        ].forEach(addSubview)

        avatarBorderView.addSubview(avatarView)
        emailContainerView.addSubview(emailIconView)
        emailContainerView.addSubview(emailLabel)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        avatarBorderView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailContainerView.translatesAutoresizingMaskIntoConstraints = false
        emailIconView.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            editButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            editButton.widthAnchor.constraint(equalToConstant: 35),
            editButton.heightAnchor.constraint(equalToConstant: 35),

            avatarBorderView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            avatarBorderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarBorderView.widthAnchor.constraint(equalToConstant: 144),
            avatarBorderView.heightAnchor.constraint(equalToConstant: 144),

            avatarView.topAnchor.constraint(equalTo: avatarBorderView.topAnchor, constant: 5),
            avatarView.leadingAnchor.constraint(equalTo: avatarBorderView.leadingAnchor, constant: 5),
            avatarView.trailingAnchor.constraint(equalTo: avatarBorderView.trailingAnchor, constant: -5),
            avatarView.bottomAnchor.constraint(equalTo: avatarBorderView.bottomAnchor, constant: -5),

            nameLabel.topAnchor.constraint(equalTo: avatarBorderView.bottomAnchor, constant: 18),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 40),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -40),

            emailContainerView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            emailContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            emailContainerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24),
            emailContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            emailIconView.leadingAnchor.constraint(equalTo: emailContainerView.leadingAnchor),
            emailIconView.centerYAnchor.constraint(equalTo: emailContainerView.centerYAnchor),

            emailLabel.topAnchor.constraint(equalTo: emailContainerView.topAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: emailIconView.trailingAnchor, constant: 6),
            emailLabel.trailingAnchor.constraint(equalTo: emailContainerView.trailingAnchor),
            emailLabel.bottomAnchor.constraint(equalTo: emailContainerView.bottomAnchor)
        ])
    }

    private func configureAppearance() {
        titleLabel.text = NSLocalizedString("user.profile.screen.title", comment: "")
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = Asset.accentColor.color

        let editConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        editButton.setImage(UIImage(systemName: "pencil", withConfiguration: editConfig), for: .normal)
        editButton.tintColor = .white
        editButton.backgroundColor = Asset.primaryGreen.color
        editButton.layer.cornerRadius = 17.5
        editButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        editButton.layer.shadowOpacity = 1
        editButton.layer.shadowOffset = CGSize(width: 0, height: 8)
        editButton.layer.shadowRadius = 14

        avatarBorderView.backgroundColor = Asset.userAvatarBorder.color
        avatarBorderView.layer.cornerRadius = 48
        avatarBorderView.layer.shadowColor = UIColor.label.withAlphaComponent(0.06).cgColor
        avatarBorderView.layer.shadowOpacity = 1
        avatarBorderView.layer.shadowOffset = CGSize(width: 0, height: 10)
        avatarBorderView.layer.shadowRadius = 18

        avatarView.layer.cornerRadius = 43
        avatarView.image = Asset.defaultUserProfilePhoto.image
        avatarView.backgroundColor = Asset.lightGreen.color

        nameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2

        let emailConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        emailIconView.image = UIImage(systemName: "envelope", withConfiguration: emailConfig)
        emailIconView.tintColor = Asset.petGray.color

        emailLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        emailLabel.textColor = Asset.petGray.color
        emailLabel.textAlignment = .center
        emailLabel.numberOfLines = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
