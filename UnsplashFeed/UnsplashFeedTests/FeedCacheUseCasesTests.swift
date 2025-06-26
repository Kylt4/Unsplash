//
//  FeedCacheUseCasesTests.swift
//  UnsplashFeedTests
//
//  Created by Christophe Bugnon on 26/06/2025.
//

import Testing

class LocalFeedCache {
}

class FeedStore {
    var messages: [String] = []
}

class FeedCacheUseCasesTests {

    @Test
    func test_init_doesNotDeliversMessageUponCreation() {
        let _ = LocalFeedCache()
        let store = FeedStore()

        #expect(store.messages == [])
    }
}
