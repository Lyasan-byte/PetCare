//
//  PetImagePickerView.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class PetImagePickerView: UIView {
    var onPhotoPickerTap: (() -> Void)?

    private var imageView: PetRemoteImageView = {
        let imageView = PetRemoteImageView(contentMode: .scaleAspectFill)
        imageView.layer.cornerRadius = 65
        return imageView
    }()

    private var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var photoPickerIcon = CircleIconView(
        symbolName: "pencil",
        iconColor: .white,
        circleColor: Asset.primaryGreen.color,
        circleSize: 22,
        iconSize: 12,
        weight: .bold
    )

    private let photoPickerTitle = TextLabel(
        font: .systemFont(ofSize: 13, weight: .semibold),
        text: L10n.Pets.Form.PhotoPicker.title,
        textColor: Asset.petGray.color
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        setupActions()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    private func setupHierarchy() {
        addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        imageContainer.addSubview(photoPickerIcon)
        addSubview(photoPickerTitle)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: topAnchor),
            imageContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageContainer.heightAnchor.constraint(equalToConstant: 130),
            imageContainer.widthAnchor.constraint(equalToConstant: 130),

            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),

            photoPickerIcon.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -7),
            photoPickerIcon.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -5),

            photoPickerTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            photoPickerTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoPickerTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoPickerTitle.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPicker))
        imageContainer.addGestureRecognizer(tap)
        imageContainer.isUserInteractionEnabled = true
    }

    @objc func didTapPicker() {
        onPhotoPickerTap?()
    }

    func setImage(_ image: UIImage?) {
        imageView.cancelLoading()
        imageView.image = image ?? UIImage(named: "defaultProfilePhoto")
    }

    func setRemoteImage(urlString: String?, imageLoader: ImageLoader) {
        imageView.setImage(urlString: urlString, imageLoader: imageLoader)
    }

    func resetImage() {
        imageView.cancelLoading()
        imageView.image = UIImage(named: "defaultProfilePhoto")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
