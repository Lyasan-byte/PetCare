//
//  NoteTextView.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class NoteTextView: UIView {
    var onNoteChange: ((String) -> Void)?

    private let background = BackgroundView(backgroundColor: Asset.petLightGray.color, cornerRadius: 28)
    private let noteTitle = TextLabel(
        font: .systemFont(ofSize: 11, weight: .medium),
        textColor: Asset.petGray.color,
        textAlignment: .left
    )

    let noteTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.showsVerticalScrollIndicator = false
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    convenience init(title: String) {
        self.init(frame: .zero)
        self.noteTitle.text = title
    }

    private func setupHierarchy() {
        addSubview(noteTitle)
        addSubview(background)
        background.addSubview(noteTextView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            noteTitle.topAnchor.constraint(equalTo: topAnchor),
            noteTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            noteTitle.trailingAnchor.constraint(equalTo: trailingAnchor),

            background.topAnchor.constraint(equalTo: noteTitle.bottomAnchor, constant: 10),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),

            noteTextView.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            noteTextView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            noteTextView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            noteTextView.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16),
            noteTextView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        noteTextView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NoteTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        onNoteChange?(textView.text)
    }
}
