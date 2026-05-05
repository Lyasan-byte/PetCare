//
//  DatePickerView.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class DatePickerView: UIView {
    var onDateChange: ((Date) -> Void)?
    private let background = BackgroundView(backgroundColor: Asset.petLightGray.color, cornerRadius: 28)

    private let pickerTitle = TextLabel(
        font: .systemFont(
            ofSize: 11,
            weight: .medium
        ),
        textColor: Asset.petGray.color,
        textAlignment: .left
    )

    private let dateIcon = UIImageView()

    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()

    private lazy var hstack: UIStackView = {
        let hstack = HStack(alignment: .center, arrangedSubviews: [dateIcon, datePicker])
        hstack.distribution = .equalSpacing
        return hstack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    convenience init(
        title: String,
        symbolName: String = "calendar",
        mode: UIDatePicker.Mode = .date,
        preferredStyle: UIDatePickerStyle = .automatic
    ) {
        self.init(frame: .zero)
        pickerTitle.text = title
        configureIcon(symbolName: symbolName)
        datePicker.datePickerMode = mode
        datePicker.preferredDatePickerStyle = preferredStyle
    }

    private func setupHierarchy() {
        addSubview(pickerTitle)
        addSubview(background)
        background.addSubview(hstack)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            pickerTitle.topAnchor.constraint(equalTo: topAnchor),
            pickerTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerTitle.trailingAnchor.constraint(equalTo: trailingAnchor),

            background.topAnchor.constraint(equalTo: pickerTitle.bottomAnchor, constant: 10),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),

            hstack.topAnchor.constraint(equalTo: background.topAnchor, constant: 12),
            hstack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            hstack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            hstack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -12)
        ])
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        dateIcon.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.locale = SettingsLanguage.current.locale
        datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
        configureIcon(symbolName: "calendar")
    }

    private func configureIcon(symbolName: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        dateIcon.preferredSymbolConfiguration = config
        dateIcon.image = UIImage(systemName: symbolName, withConfiguration: config)
        dateIcon.tintColor = Asset.accentColor.color
    }

    func updateLocale(_ locale: Locale) {
        datePicker.locale = locale
    }

    func setTitle(_ title: String) {
        pickerTitle.text = title
    }

    @objc private func dateDidChange() {
        onDateChange?(datePicker.date)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
