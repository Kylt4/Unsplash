//
//  ImageDataLoader.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 27/01/2023.
//

import Foundation

public protocol ImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
