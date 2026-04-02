//
//  ImageLoader.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import Combine
import UIKit

protocol ImageLoader {
    func loadImage(from url: URL) -> AnyPublisher<UIImage, Error>
}
