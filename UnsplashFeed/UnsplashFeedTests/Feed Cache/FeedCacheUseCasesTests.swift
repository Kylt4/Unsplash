//
//  FeedCacheUseCasesTests.swift
//  UnsplashFeedTests
//
//  Created by Christophe Bugnon on 26/06/2025.
//

import Foundation
import XCTest
import UnsplashFeed

class FeedCacheUseCasesTests: XCTestCase {

    func test_init_doesNotDeliversMessageUponCreation() {
        let store = FeedStoreSpy()
        let _ = LocalFeedCache(store: store)

        XCTAssertTrue(store.messages.isEmpty)
    }

    func test_save_doesNotRequestFeedInsertionOnDeletionError() async {
        let store = FeedStoreSpy()
        let sut = LocalFeedCache(store: store)
        let deletionError = NSError(domain: "deletion error", code: 0)

        Task { try await sut.save([]) }
        await store.completeDeletionWithError(deletionError)

        XCTAssertEqual(store.messages, [.deleteCachedFeed])
    }

    func test_save_requestFeedInsertionOnSucessfulDeletion() async {
        let store = FeedStoreSpy()
        let sut = LocalFeedCache(store: store)
        let feed = uniqueFeed()

        Task { try await sut.save(feed) }
        await store.completeDeletionSuccessfully()
        await store.completeInsertionSuccessfully()

        XCTAssertEqual(store.messages, [.deleteCachedFeed, .insert(feed.map(\.toLocal))])
    }

    func test_save_failsOnDeletionError() async {
        let store = FeedStoreSpy()
        let sut = LocalFeedCache(store: store)
        let deletionError = NSError(domain: "deletion error", code: 0)

        let task = Task {
            try await sut.save([])
        }

        await expect(task, toCompleteWith: deletionError, when: {
            await store.completeDeletionWithError(deletionError)
        })
    }

    func test_save_failsOnInsertionError() async {
        let store = FeedStoreSpy()
        let sut = LocalFeedCache(store: store)
        let insertionError = NSError(domain: "insertion error", code: 0)

        let task = Task {
            try await sut.save([])
        }

        await expect(task, toCompleteWith: insertionError) {
            await store.completeDeletionSuccessfully()
            await store.completeInsertionWithError(insertionError)
        }
    }

    func test_save_succeedsOnSuccessfulCacheInsertion() async {
        let store = FeedStoreSpy()
        let sut = LocalFeedCache(store: store)

        let task = Task { try await sut.save([]) }

        await expect(task, toCompleteWith: nil) {
            await store.completeDeletionSuccessfully()
            await store.completeInsertionSuccessfully()
        }
    }

    // MARK: - Helpers

    func expect(
        _ task: Task<Void, Error>,
        toCompleteWith expectedError: Error?,
        when action: () async -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        await action()

        do {
            try await task.value
            if expectedError != nil {
                XCTFail("Expected error but got success", file: file, line: line)
            }
        } catch {
            XCTAssertEqual(error as NSError?, expectedError as NSError?, file: file, line: line)
        }
    }
}
