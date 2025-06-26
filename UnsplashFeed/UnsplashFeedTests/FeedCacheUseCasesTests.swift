//
//  FeedCacheUseCasesTests.swift
//  UnsplashFeedTests
//
//  Created by Christophe Bugnon on 26/06/2025.
//

import Foundation
import XCTest

final class LocalFeedCache: @unchecked Sendable {
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

class FeedCacheUseCasesTests: XCTestCase {

    func test_init_doesNotDeliversMessageUponCreation() {
        let store = FeedStore()
        let _ = LocalFeedCache(store: store)

        XCTAssertTrue(store.messages.isEmpty)
    }

    func test_save_doesNotRequestFeedInsertionOnDeletionError() async {
        let store = FeedStore()
        let sut = LocalFeedCache(store: store)
        let deletionError = NSError(domain: "deletion error", code: 0)

        await expect(sut, store: store, toCompleteWith: [.deleteCachedFeed]) {
            store.completeDeletionWithError(deletionError)
        }
    }


    func test_save_requestFeedInsertionOnSucessfulDeletion() async throws {
        let store = FeedStore()
        let sut = LocalFeedCache(store: store)

        await expect(sut, store: store, toCompleteWith: [.deleteCachedFeed, .insert], when: {
            store.completeDeletionSuccessfully()
            store.completeInsertionSucessfully()
        })
    }

    func test_save_failsOnDeletionError() async {
        let store = FeedStore()
        let sut = LocalFeedCache(store: store)
        let deletionError = NSError(domain: "deletion error", code: 0)

        let task = Task { try await sut.save() }

        try? await Task.sleep(nanoseconds: 1_000_000)
        store.completeDeletionWithError(deletionError)

        do {
            try await task.value
            XCTFail("Expected error but save succeeded")
        } catch {
            XCTAssertEqual(error as NSError, deletionError)
        }
    }

    // MARK: - Helpers

    func expect(_ sut: LocalFeedCache,
                store: FeedStore,
                toCompleteWith expectedMessages: [FeedStore.ReceivedMessage],
                when action: () -> Void,
                file: StaticString = #filePath,
                line: UInt = #line) async {

        Task { try await sut.save() }

        try? await Task.sleep(nanoseconds: 1_000_000)
        action()

        XCTAssertEqual(store.messages, expectedMessages, file: file, line: line)
    }
}
