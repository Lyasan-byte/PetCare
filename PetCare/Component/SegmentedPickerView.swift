//
//  SegmentedPickerView.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class SegmentedPickerView: UISegmentedControl {
    
    var onValueChanged: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(items: [String], selectedIndex: Int = 0) {
        self.init(frame: .zero)
        configureSegments(items: items, selectedIndex: selectedIndex)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        setTitleTextAttributes([.foregroundColor : Asset.petGray.color], for: .normal)
        setTitleTextAttributes([.foregroundColor : Asset.accentColor.color], for: .selected)
    }
    
    func configureSegments(items: [String], selectedIndex: Int = 0) {
        removeAllSegments()
        
        for (index, item) in items.enumerated() {
            insertSegment(withTitle: item, at: index, animated: false)
        }
        
        if !items.isEmpty {
            selectedSegmentIndex = min(selectedIndex, items.count - 1)
        }
    }
    
    @objc private func valueChanged() {
        onValueChanged?(selectedSegmentIndex)
    }
    
    func setSelectedIndex(_ index: Int) {
        guard index >= 0, index < numberOfSegments else { return }
        guard selectedSegmentIndex != index else { return }
        selectedSegmentIndex = index
    }
    
    var selectedTitle: String? {
        titleForSegment(at: selectedSegmentIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
