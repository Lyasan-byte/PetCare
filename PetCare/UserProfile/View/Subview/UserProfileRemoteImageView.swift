//
//  UserProfileRemoteImageView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import UIKit
import Combine

final class UserProfileRemoteImageView: UIImageView {
    private var imageLoadCancellable: AnyCancellable?
    private var currentURL: URL?

    init(contentMode: UIView.ContentMode = .scaleAspectFill) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = contentMode
        clipsToBounds = true
        image = Asset.defaultUserProfilePhoto.image
    }

    func setImage(urlString: String?, imageLoader: ImageLoader) {
        cancelLoading()
        image = Asset.defaultUserProfilePhoto.image

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
