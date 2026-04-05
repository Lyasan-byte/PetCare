//
//  UserProfileEditPhotoPickerView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import UIKit

final class UserProfileEditPhotoPickerView: UIView {
    var onTap: (() -> Void)?

    private let avatarBorderView = UIView()
    private let avatarView = UserProfileRemoteImageView()
    private let editBadge = CircleIconView(
        symbolName: "pencil",
        iconColor: .white,
        circleColor: Asset.accentColor.color,
        circleSize: 30,
        iconSize: 14,
        weight: .bold,
        borderColor: .white,
        shadowColor: UIColor.black.withAlphaComponent(0.15)
    )
    private let titleLabel = TextLabel(
        font: .systemFont(ofSize: 15, weight: .semibold),
        text: NSLocalizedString("user.profile.edit.photo.title", comment: ""),
        textColor: .label
    )
    private let subtitleLabel = TextLabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        text: NSLocalizedString("user.profile.edit.photo.subtitle", comment: ""),
        textColor: Asset.petGray.color
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
        setupActions()
    }

    private func setupHierarchy() {
        addSubview(avatarBorderView)
        avatarBorderView.addSubview(avatarView)
        avatarBorderView.addSubview(editBadge)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            avatarBorderView.topAnchor.constraint(equalTo: topAnchor),
            avatarBorderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarBorderView.widthAnchor.constraint(equalToConstant: 144),
            avatarBorderView.heightAnchor.constraint(equalToConstant: 144),

            avatarView.topAnchor.constraint(equalTo: avatarBorderView.topAnchor, constant: 5),
            avatarView.leadingAnchor.constraint(equalTo: avatarBorderView.leadingAnchor, constant: 5),
            avatarView.trailingAnchor.constraint(equalTo: avatarBorderView.trailingAnchor, constant: -5),
            avatarView.bottomAnchor.constraint(equalTo: avatarBorderView.bottomAnchor, constant: -5),

            editBadge.trailingAnchor.constraint(equalTo: avatarBorderView.trailingAnchor, constant: -2),
            editBadge.bottomAnchor.constraint(equalTo: avatarBorderView.bottomAnchor, constant: -2),

            titleLabel.topAnchor.constraint(equalTo: avatarBorderView.bottomAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        avatarBorderView.translatesAutoresizingMaskIntoConstraints = false
        avatarBorderView.backgroundColor = Asset.userAvatarBorder.color
        avatarBorderView.layer.cornerRadius = 48
        avatarBorderView.layer.shadowColor = UIColor.label.withAlphaComponent(0.06).cgColor
        avatarBorderView.layer.shadowOpacity = 1
        avatarBorderView.layer.shadowOffset = CGSize(width: 0, height: 10)
        avatarBorderView.layer.shadowRadius = 18

        avatarView.layer.cornerRadius = 43
        avatarView.backgroundColor = Asset.lightGreen.color
        avatarView.image = Asset.defaultUserProfilePhoto.image

        titleLabel.textAlignment = .center
        subtitleLabel.textAlignment = .center
    }

    private func setupActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPicker))
        avatarBorderView.addGestureRecognizer(tap)
        avatarBorderView.isUserInteractionEnabled = true
    }

    @objc private func didTapPicker() {
        onTap?()
    }

    func setImage(_ image: UIImage?) {
        avatarView.cancelLoading()
        avatarView.image = image ?? Asset.defaultUserProfilePhoto.image
    }

    func setRemoteImage(urlString: String?, imageLoader: ImageLoader) {
        avatarView.setImage(urlString: urlString, imageLoader: imageLoader)
    }

    func resetImage() {
        avatarView.cancelLoading()
        avatarView.image = Asset.defaultUserProfilePhoto.image
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
