//
//  FeedStore.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 26/06/2025.
//

import Foundation

public protocol FeedStore: Sendable {
    func deleteCachedFeed() async throws
    func insert(_ feed: [LocalFeedImage]) async throws
}
