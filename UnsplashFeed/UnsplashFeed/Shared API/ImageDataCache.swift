//
//  ImageDataCache.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 23/07/2024.
//

import Foundation

public protocol ImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
