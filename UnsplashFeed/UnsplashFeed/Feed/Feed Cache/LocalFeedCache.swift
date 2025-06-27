//
//  LocalFeedCache.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 26/06/2025.
//

import Foundation

public final class LocalFeedCache {
    private let store: FeedStore

    public init(store: FeedStore) {
        self.store = store
    }

    public func save(_ feed: [FeedImage]) async throws {
        try await store.deleteCachedFeed()
        try await store.insert(feed.map(\.toLocal))
    }
}

public extension FeedImage {
    var toLocal: LocalFeedImage {
        return LocalFeedImage(
            id: id,
            title: title,
            imageURL: imageURL,
            likes: likes,
            profile: LocalFeedProfile(
                id: profile.id,
                name: profile.name,
                username: profile.username,
                imageURL: profile.imageURL)
        )
    }
}
