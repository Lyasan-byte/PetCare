//
//  MenuBarButton.swift
//  PetCare
//
//  Created by Ляйсан on 2/5/26.
//

import UIKit

final class MenuBarButton: UIButton {
    var onSelect: ((Int) -> Void)?

    private var options: [String] = []
    private var selectedIndex: Int = 0

    init(
        systemImageName: String = "line.3.horizontal.decrease",
        tintColor: UIColor = Asset.accentColor.color
    ) {
        super.init(frame: .zero)

        setImage(UIImage(systemName: systemImageName), for: .normal)
        self.tintColor = tintColor

        showsMenuAsPrimaryAction = true
    }

    func configure(
        options: [String],
        selectedIndex: Int = 0
    ) {
        self.options = options
        self.selectedIndex = selectedIndex
        menu = makeMenu()
    }

    private func makeMenu() -> UIMenu {
        let actions = options.enumerated().map { index, title in
            UIAction(
                title: title,
                state: selectedIndex == index ? .on : .off
            ) { [weak self] _ in
                self?.select(index)
            }
        }

        return UIMenu(children: actions)
    }

    private func select(_ index: Int) {
        selectedIndex = index
        menu = makeMenu()
        onSelect?(index)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
