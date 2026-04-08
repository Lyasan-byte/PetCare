//
//  TipView.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import UIKit

final class TipView: UIView {
    var onTipTap: (() -> Void)?

    var tipView = BackgroundView(backgroundColor: Asset.lightPink.color)

    lazy var stack: UIStackView = {
        let stack = HStack(alignment: .top, arrangedSubviews: [tipIcon, textStack])
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = .init(top: 20, leading: 15, bottom: 20, trailing: 20)
        return stack
    }()

    lazy var textStack = VStack(alignment: .top, arrangedSubviews: [tipTitle, tipDescription])

    var tipIcon: UIImageView = {
        let imageView = ImageView()
        imageView.image = UIImage(systemName: "lightbulb")
        imageView.tintColor = Asset.pinkAccent.color
        return imageView
    }()

    lazy var tipTitle = createTipText(font: .systemFont(ofSize: 14, weight: .semibold))
    lazy var tipDescription = createTipText(font: .systemFont(ofSize: 12.5, weight: .regular))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()

        setupAction()
    }

    private func setupHierarchy() {
        addSubview(tipView)
        tipView.addSubview(stack)
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        tipTitle.text = L10n.Pets.Main.Tip.title
    }

    private func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTip))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    @objc private func didTapTip() {
        onTipTap?()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tipView.topAnchor.constraint(equalTo: topAnchor),
            tipView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tipView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tipView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stack.topAnchor.constraint(equalTo: tipView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: tipView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: tipView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: tipView.bottomAnchor),

            tipIcon.widthAnchor.constraint(equalToConstant: 24),
            tipIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func setText(text: String) {
        setAttributedText(text, for: tipDescription, font: tipDescription.font, lineSpacing: 4)
    }

    private func setAttributedText(_ text: String, for label: UILabel, font: UIFont, lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        label.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .paragraphStyle: paragraphStyle
            ]
        )
    }

    private func createTipText(font: UIFont) -> UILabel {
        let title = UILabel()
        title.font = font
        title.numberOfLines = 0
        title.textColor = Asset.pinkAccent.color

        return title
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
