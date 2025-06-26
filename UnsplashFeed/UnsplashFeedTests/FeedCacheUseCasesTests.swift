//
//  FeedCacheUseCasesTests.swift
//  UnsplashFeedTests
//
//  Created by Christophe Bugnon on 26/06/2025.
//

import Testing
import Foundation

class LocalFeedCache {
    private let store: FeedStore

    init(store: FeedStore) {
        self.store = store
    }

    func save() async throws {
        try await store.deleteCachedFeed()
        await store.insert()
    }
}

class FeedStore: @unchecked Sendable {
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert
    }

    private(set) var messages: [ReceivedMessage] = []

    // MARK: - Continuations
    
    private var deletionContinuation: CheckedContinuation<Void, Error>?
    private var insertionContinuation: CheckedContinuation<Void, Never>?

    // MARK: - Deletions

    func deleteCachedFeed() async throws {
        messages.append(.deleteCachedFeed)
        return try await withCheckedThrowingContinuation { continuation in
            deletionContinuation = continuation
        }
    }

    func completeDeletionSuccessfully() {
        deletionContinuation?.resume()
        deletionContinuation = nil
    }

    func completeDeletionWithError(_ error: Error) {
        deletionContinuation?.resume(throwing: error)
        deletionContinuation = nil
    }

    // MARK: - Insertions

    func insert() async {
        messages.append(.insert)
        await withCheckedContinuation { continuation in
            insertionContinuation = continuation
        }
    }

    func completeInsertionSucessfully() {
        insertionContinuation?.resume()
        insertionContinuation = nil
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
    func test_save_doesNotRequestFeedInsertionOnDeletionError() async {
        let store = FeedStore()
        let sut = LocalFeedCache(store: store)
        let anyError = NSError(domain: "any error", code: 0)

        Task {
            try await sut.save()
        }

        try? await Task.sleep(nanoseconds: 1_000_000)
        store.completeDeletionWithError(anyError)

        #expect(store.messages == [.deleteCachedFeed])
    }


    @Test
    func test_save_requestFeedInsertionOnSucessfulDeletion() async throws {
        let store = FeedStore()
        let sut = LocalFeedCache(store: store)

        Task {
            try await sut.save()
        }

        try? await Task.sleep(nanoseconds: 1_000_000)
        store.completeDeletionSuccessfully()
        store.completeInsertionSucessfully()

        #expect(store.messages == [.deleteCachedFeed, .insert])
    }
}
