//
//  FeedCacheUseCasesTests.swift
//  UnsplashFeedTests
//
//  Created by Christophe Bugnon on 26/06/2025.
//

import Testing

class LocalFeedCache {
    private let store: FeedStore

    init(store: FeedStore) {
        self.store = store
    }

    func save() {
        store.deleteCachedFeed()
    }
}

class FeedStore {
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
    }

    private(set) var messages: [ReceivedMessage] = []

    func deleteCachedFeed() {
        messages.append(.deleteCachedFeed)
    }
}

class FeedCacheUseCasesTests {

    @Test
    func test_init_doesNotDeliversMessageUponCreation() {
        let store = FeedStore()
        let _ = LocalFeedCache(store: store)

        #expect(store.messages == [])
    }

    @Test
    func test_save_doesNotRequestFeedInsertionOnDeletionError() {
        let store = FeedStore()
        let sut = LocalFeedCache(store: store)

        sut.save()

        #expect(store.messages == [.deleteCachedFeed])
    }
}
