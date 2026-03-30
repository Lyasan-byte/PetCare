//
//  TextFieldView.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class TextFieldView: UIView {
    var onTextChanged: ((String) -> Void)?
    
    private let background = BackgroundView(backgroundColor: Asset.petLightGray.color, cornerRadius: 28)
    
    let textFieldTitle = TextLabel(font: .systemFont(ofSize: 11, weight: .medium), textColor: Asset.petGray.color, textAlignment: .left)
    var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter text"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }
    
    convenience init(title: String, placeholder: String, keyboardType: UIKeyboardType = .default) {
        self.init(frame: .zero)
        textFieldTitle.text = title
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
    }
    
    @objc private func textDidChange() {
        onTextChanged?(textField.text ?? "")
    }
    
    private func setupHierarchy() {
        addSubview(textFieldTitle)
        addSubview(background)
        background.addSubview(textField)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            textFieldTitle.topAnchor.constraint(equalTo: topAnchor),
            textFieldTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            textFieldTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            background.topAnchor.constraint(equalTo: textFieldTitle.bottomAnchor, constant: 10),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            textField.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            textField.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16)
        ])
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
