//
//  MenuPickerView.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import UIKit

final class MenuPickerView: UIView {
    var onChangeValue: ((Int) -> Void)?
    
    private var options: [String] = []
    private(set) var selectedIndex: Int = 0
    
    private let pickerTitle = TextLabel(
        font: .systemFont(
            ofSize: 11,
            weight: .medium
        ),
        textColor: Asset.petGray.color,
        textAlignment: .left
    )
    
    private let selectionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Asset.petLightGray.color
        button.layer.cornerRadius = 27
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
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
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Asset.accentColor.color
        return imageView
    }()
    
    private lazy var textStack = HStack(alignment: .center, distribution: .equalSpacing, arrangedSubviews: [optionText, icon])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    convenience init(title: String, options: [String]) {
        self.init(frame: .zero)
        self.pickerTitle.text = title
        self.options = options
        
        updateSelection(index: 0, sendAction: false)
    }
    
    private func setupHierarchy() {
        addSubview(pickerTitle)
        addSubview(selectionButton)
        selectionButton.addSubview(textStack)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerTitle.topAnchor.constraint(equalTo: topAnchor),
            pickerTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            selectionButton.topAnchor.constraint(equalTo: pickerTitle.bottomAnchor, constant: 10),
            selectionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            textStack.topAnchor.constraint(equalTo: selectionButton.topAnchor, constant: 16),
            textStack.leadingAnchor.constraint(equalTo: selectionButton.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: selectionButton.trailingAnchor, constant: -16),
            textStack.bottomAnchor.constraint(equalTo: selectionButton.bottomAnchor, constant: -16)
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
            UIAction(title: element,
                     state: selectedIndex == index ? .on : .off
            ) { [weak self] _ in
                self?.updateSelection(index: index, sendAction: true)
            }
        }
        return UIMenu(children: actions)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
