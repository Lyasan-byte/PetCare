//
//  ImageLoadService.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import Combine
import UIKit

final class ImageLoadService: ImageLoader {
    private let cache = NSCache<NSURL, UIImage>()
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func loadImage(from url: URL) -> AnyPublisher<UIImage, Error> {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return Just(cachedImage)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: url)
            .tryMap { [weak self] output in
                guard let response = output.response as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode) else {
                    throw ImageLoaderError.invalidResponse
                }

                guard !output.data.isEmpty else {
                    throw ImageLoaderError.emptyData
                }

                guard let image = UIImage(data: output.data) else {
                    throw ImageLoaderError.invalidImageData
                }

                self?.cache.setObject(image, forKey: url as NSURL)
                return image
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
