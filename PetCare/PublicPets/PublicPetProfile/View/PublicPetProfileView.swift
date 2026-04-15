//
//  PublicPetProfileView.swift
//  PetCare
//
//  Created by Ляйсан on 3/4/26.
//

import UIKit

final class PublicPetProfileView: UIView {
    var onBreedTap: (() -> Void)?
    
    private let loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    private let petProfileCard = PetProfileCardView(isPublicPet: true)
    private let ownerRow = PublicPetOwnerView()
    private let gameScoreRow = PublicPetGameScoreView()
    private let note = PetProfileNoteView()

    private let scrollView = ScrollView()
    private lazy var scrollContent = VStack(
        spacing: 16,
        arrangedSubviews: [
            petProfileCard,
            ownerRow,
            gameScoreRow,
            note
        ]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        bindActions()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    private func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(scrollContent)
        addSubview(loader)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            scrollContent.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContent.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContent.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContent.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContent.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func bindActions() {
        petProfileCard.onBreedTap = { [weak self] in
            self?.onBreedTap?()
        }
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }
        scrollContent.isHidden = isLoading
        scrollView.isUserInteractionEnabled = !isLoading
    }

    func setData(pet: Pet, user: UserProfileUser, imageLoader: ImageLoader) {
        petProfileCard.setData(isPublic: true, pet: pet, imageLoader: imageLoader)
        note.noteText.text = pet.note
        note.isHidden = pet.note.isEmpty
        ownerRow.setData(user: user, imageLoader: imageLoader)
        gameScoreRow.setData(gameScore: pet.gameScore)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
