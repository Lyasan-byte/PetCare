//
//  PetProfileNoteView.swift
//  PetCare
//
//  Created by Ляйсан on 30/3/26.
//

import UIKit

final class PetProfileNoteView: UIView {
    private let backgroundView = BackgroundView(backgroundColor: Asset.lightPurple.color)
    private let title = TextLabel(font: .systemFont(ofSize: 13, weight: .semibold), text: "FEATURES / NOTES", textColor: Asset.purpleAccent.color, textAlignment: .left)
    
    private var noteText: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = Asset.purpleAccent.color
        textView.font = .systemFont(ofSize: 14.5, weight: .regular)
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        noteText.text = text
    }
    
    private func setupHierarchy() {
        addSubview(backgroundView)
        backgroundView.addSubview(title)
        backgroundView.addSubview(noteText)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            title.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            noteText.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            noteText.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            noteText.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            noteText.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
            noteText.heightAnchor.constraint(lessThanOrEqualToConstant: 90)
        ])
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        noteText.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

