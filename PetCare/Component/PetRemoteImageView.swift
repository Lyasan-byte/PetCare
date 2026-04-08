//
//  PetRemoteImageView.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import UIKit
import Combine

final class PetRemoteImageView: UIImageView {
    private var imageLoadCancellable: AnyCancellable?
    private var currentURL: URL?

    init(contentMode: UIView.ContentMode = .scaleAspectFill) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = contentMode
        clipsToBounds = true
        image = UIImage(named: "defaultProfilePhoto")
    }

    func setImage(urlString: String?, imageLoader: ImageLoader) {
        cancelLoading()
        image = UIImage(named: "defaultProfilePhoto")

        guard let urlString,
            let url = URL(string: urlString) else {
            return
        }

        currentURL = url

        imageLoadCancellable = imageLoader.loadImage(from: url)
            .sink { _ in
            } receiveValue: { [weak self] loadedImage in
                guard let self else { return }
                guard self.currentURL == url else { return }
                self.image = loadedImage
            }
    }

    func cancelLoading() {
        imageLoadCancellable?.cancel()
        imageLoadCancellable = nil
        currentURL = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
