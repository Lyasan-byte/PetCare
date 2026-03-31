//
//  PetsMainView.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import UIKit

final class PetsMainView: UIView {
    var onAddPetButtonTap: (() -> ())?
    
    let loader = UIActivityIndicatorView()
    let petsTableView = PetsTableView()
    private let emptyStateView = EmptyStateView(title: "No Pets", subtitle: "Tap the plus button to add your first friend.", image: "pawprint")
    
    private let viewContainer = UIView()
    
    private let petsHeader = PetsViewHeader()
    private let quickActionsButtonsHeader = QuickActionButtonsHeader()
    private let quickActionButtonsCollection = QuickActionButtonsCollectionView()
    let addPetButton = CircleIconView(symbolName: "plus", iconColor: .white, circleColor: Asset.accentColor.color, circleSize: 52, iconSize: 18, weight: .medium, shadowColor: Asset.accentColor.color)
    private let petTableViewTitle = TextLabel(text: "Your Family", textAlignment: .left)
    
    let tip = TipView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
        setupAction()
    }
    
    func setContentHidden(_ isHidden: Bool) {
        viewContainer.isHidden = isHidden
    }
    
    private func setupHierarchy() {
        addSubview(viewContainer)
        addSubview(loader)
        addSubview(addPetButton)
        addSubview(emptyStateView)
        viewContainer.addSubview(petsHeader)
        viewContainer.addSubview(quickActionsButtonsHeader)
        viewContainer.addSubview(quickActionButtonsCollection)
        viewContainer.addSubview(tip)
        viewContainer.addSubview(petTableViewTitle)
        viewContainer.addSubview(petsTableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: topAnchor),
            viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            petsHeader.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 60),
            petsHeader.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 16),
            petsHeader.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -16),
            
            quickActionsButtonsHeader.topAnchor.constraint(equalTo: petsHeader.bottomAnchor, constant: 35),
            quickActionsButtonsHeader.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 16),
            quickActionsButtonsHeader.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -16),
        
            quickActionButtonsCollection.topAnchor.constraint(equalTo: quickActionsButtonsHeader.bottomAnchor, constant: 10),
            quickActionButtonsCollection.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            quickActionButtonsCollection.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            quickActionButtonsCollection.heightAnchor.constraint(equalToConstant: 110),
            
            tip.topAnchor.constraint(equalTo: quickActionButtonsCollection.bottomAnchor, constant: 10),
            tip.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 16),
            tip.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -16),
            
            petTableViewTitle.topAnchor.constraint(equalTo: tip.bottomAnchor, constant: 10),
            petTableViewTitle.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 16),
            petTableViewTitle.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -16),
            
            petsTableView.topAnchor.constraint(equalTo: petTableViewTitle.bottomAnchor, constant: 10),
            petsTableView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 16),
            petsTableView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -16),
            petsTableView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor),
            
            addPetButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addPetButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            emptyStateView.topAnchor.constraint(equalTo: petTableViewTitle.bottomAnchor, constant: 16),
            emptyStateView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 16),
            emptyStateView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -16),
            
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func showEmptyStateView(_ isHidden: Bool) {
        emptyStateView.isHidden = !isHidden
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }
        
        loader.isHidden = !isLoading
        viewContainer.isHidden = isLoading
        addPetButton.isHidden = isLoading
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        loader.isHidden = true
        loader.style = .medium
        loader.hidesWhenStopped = true
    }
    
    private func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didAddPetButtonTap))
        addPetButton.addGestureRecognizer(tap)
        addPetButton.isUserInteractionEnabled = true
    }
    
    @objc private func didAddPetButtonTap() {
        onAddPetButtonTap?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
