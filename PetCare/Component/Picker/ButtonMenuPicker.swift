//
//  ButtonMenuPicker.swift
//  PetCare
//
//  Created by Ляйсан on 16/4/26.
//

import UIKit

final class ButtonMenuPicker: UIView {
    var onChangeValue: ((Int) -> Void)?

    private var options: [String] = []
    private(set) var selectedIndex: Int = 0
    private let symbolName: String
    
    private lazy var selectionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 27
        button.setImage(UIImage(systemName: symbolName), for: .normal)
        button.setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: 18, weight: .medium),
            forImageIn: .normal
        )
        button.showsMenuAsPrimaryAction = true
        return button
    }()

    private let optionText = TextLabel(
        font: .systemFont(
            ofSize: 16,
            weight: .regular
        ),
        textColor: .label,
        textAlignment: .left
    )

    init(symbolName: String, options: [String]) {
        self.symbolName = symbolName
        self.options = options
        
        super.init(frame: .zero)

        setupHierarchy()
        setupLayout()
        updateSelection(index: 0, sendAction: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        addSubview(selectionButton)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectionButton.topAnchor.constraint(equalTo: topAnchor),
            selectionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectionButton.heightAnchor.constraint(equalToConstant: 54),
            selectionButton.widthAnchor.constraint(equalToConstant: 54)
        ])
    }

    func updateSelection(index: Int, sendAction: Bool) {
        selectedIndex = index
        optionText.text = options[index]

        selectionButton.menu = makeMenu()

        if sendAction {
            onChangeValue?(index)
        }
    }

    private func makeMenu() -> UIMenu {
        let actions = options.enumerated().map { index, element in
            UIAction(
                title: element,
                state: selectedIndex == index ? .on : .off
            ) { [weak self] _ in
                self?.updateSelection(index: index, sendAction: true)
            }
        }
        return UIMenu(children: actions)
    }
}
