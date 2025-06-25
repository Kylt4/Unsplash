//
//  LocalImageDataLoader.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 23/07/2024.
//

import Foundation

public class LocalImageDataLoader: ImageDataLoader, ImageDataCache {
    private var cache: NSCache<NSString, NSData>

    public init() {
        self.cache = NSCache<NSString, NSData>()
    }

    public func loadImageData(from url: URL) throws -> Data {
        guard let imageCache = cache.object(forKey: NSString(string: url.absoluteString)) else {
            throw NSError(domain: "Not cached imaged for url: \(url.absoluteString)", code: 0)
        }
        return Data(referencing: imageCache)
    }

    public func save(_ data: Data, for url: URL) throws {
        cache.setObject(NSData(data: data), forKey: NSString(string: url.absoluteString))
    }
}
