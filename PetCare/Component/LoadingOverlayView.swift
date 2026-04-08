//
//  LoadingOverlayView.swift
//  PetCare
//
//  Created by Ляйсан on 7/4/26.
//

import UIKit

final class LoadingOverlayView: UIView {
    private let dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.75)
        return view
    }()

    private let loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .medium
        view.hidesWhenStopped = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        isHidden = true
    }

    convenience init() {
        self.init(frame: .zero)
    }

    private func setupHierarchy() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(dimView)
        addSubview(loader)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: topAnchor),
            dimView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: bottomAnchor),

            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func setLoading(_ isLoading: Bool) {
        isHidden = !isLoading

        if isLoading {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
