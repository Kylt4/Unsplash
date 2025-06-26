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
        try await store.insert()
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
    private var insertionContinuation: CheckedContinuation<Void, Error>?

    // MARK: - Deletions

    func deleteCachedFeed() async throws {
        messages.append(.deleteCachedFeed)
        return try await withCheckedThrowingContinuation { continuation in
            deletionContinuation = continuation
        }
    }

    func completeDeletionSuccessfully() async {
        await waitForContinuation()
        deletionContinuation?.resume()
        deletionContinuation = nil
    }

    func completeDeletionWithError(_ error: Error) async {
        await waitForContinuation()
        deletionContinuation?.resume(throwing: error)
        deletionContinuation = nil
    }

    // MARK: - Insertions

    func insert() async throws {
        messages.append(.insert)
        try await withCheckedThrowingContinuation { continuation in
            insertionContinuation = continuation
        }
    }

    func completeInsertionSuccessfully() async {
        await waitForContinuation()
        insertionContinuation?.resume()
        insertionContinuation = nil
    }

    func completeInsertionWithError(_ error: Error) async {
        await waitForContinuation()
        insertionContinuation?.resume(throwing: error)
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
            await store.completeDeletionWithError(deletionError)
        }
    }

    func test_save_requestFeedInsertionOnSucessfulDeletion() async {
        let store = FeedStore()
        let sut = LocalFeedCache(store: store)

        await expect(sut, store: store, toCompleteWith: [.deleteCachedFeed, .insert], when: {
            await store.completeDeletionSuccessfully()
            await store.completeInsertionSuccessfully()
        })
    }

    func test_save_failsOnDeletionError() async {
        let store = FeedStore()
        let sut = LocalFeedCache(store: store)
        let deletionError = NSError(domain: "deletion error", code: 0)

        await expect(sut, toCompleteWith: deletionError, when: {
            await store.completeDeletionWithError(deletionError)
        })
    }

    func test_save_failsOnInsertionError() async {
        let store = FeedStore()
        let sut = LocalFeedCache(store: store)
        let insertionError = NSError(domain: "insertion error", code: 0)

        await expect(sut, toCompleteWith: insertionError) {
            await store.completeDeletionSuccessfully()
            await store.completeInsertionWithError(insertionError)
        }
    }

    func test_save_succeedsOnSuccessfulCacheInsertion() async {
        let store = FeedStore()
        let sut = LocalFeedCache(store: store)

        await expect(sut, toCompleteWith: nil) {
            await store.completeDeletionSuccessfully()
            await store.completeInsertionSuccessfully()
        }
    }

    // MARK: - Helpers

    func expect(_ sut: LocalFeedCache,
                store: FeedStore,
                toCompleteWith expectedMessages: [FeedStore.ReceivedMessage],
                when action: () async -> Void,
                file: StaticString = #filePath,
                line: UInt = #line) async {

        Task { try await sut.save() }

        try? await Task.sleep(nanoseconds: 1_000_000)
        await action()

        XCTAssertEqual(store.messages, expectedMessages, file: file, line: line)
    }

    func expect(_ sut: LocalFeedCache,
                toCompleteWith expectedError: Error?,
                when action: () async -> Void,
                file: StaticString = #filePath,
                line: UInt = #line) async {

        let task = Task { try await sut.save() }

        await action()

        var receivedError: Error?
        do {
            try await task.value
        } catch {
            receivedError = error
        }

        XCTAssertEqual(receivedError as? NSError, expectedError as? NSError, file: file, line: line)
    }
}

func waitForContinuation() async {
    try? await Task.sleep(nanoseconds: 1_000_000)
}
