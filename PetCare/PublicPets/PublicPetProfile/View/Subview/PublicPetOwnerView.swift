//
//  PublicPetOwnerView.swift
//  PetCare
//
//  Created by Ляйсан on 3/4/26.
//

import UIKit

final class PublicPetOwnerView: UIView {
    private let background = BackgroundView(backgroundColor: Asset.lightPurple.color)
    private let ownerImage: PetRemoteImageView = {
        let imageView = PetRemoteImageView()
        imageView.layer.cornerRadius = 20
        return imageView
    }()

    private let ownerTitle = TextLabel(
        font: .systemFont(
            ofSize: 14,
            weight: .regular
        ),
        text: "Owned by",
        textColor: Asset.purpleAccent.color,
        textAlignment: .left
    )
    private let ownerName = TextLabel(
        font: .systemFont(
            ofSize: 22,
            weight: .semibold
        ),
        textColor: Asset.purpleAccent.color,
        textAlignment: .left
    )

    private lazy var textStack = VStack(
        spacing: 10,
        arrangedSubviews: [
            ownerTitle,
            ownerName
        ]
    )
    private lazy var contentStack = HStack(
        spacing: 16,
        alignment: .center,
        arrangedSubviews: [
            ownerImage,
            textStack
        ]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    private func setupHierarchy() {
        addSubview(background)
        background.addSubview(contentStack)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16),

            ownerImage.widthAnchor.constraint(equalToConstant: 40),
            ownerImage.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setData(user: UserProfileUser, imageLoader: ImageLoader) {
        ownerImage.setImage(urlString: user.avatarURLString, imageLoader: imageLoader)
        self.ownerName.text = user.firstName + " " + user.lastName
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
