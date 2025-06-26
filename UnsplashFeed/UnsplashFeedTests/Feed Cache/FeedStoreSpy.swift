//
//  FeedStoreSpy.swift
//  UnsplashFeedTests
//
//  Created by Christophe Bugnon on 26/06/2025.
//

import Foundation
import UnsplashFeed

class FeedStoreSpy: FeedStore {
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert(_ feed: [LocalFeedImage])
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

    func insert(_ feed: [LocalFeedImage]) async throws {
        messages.append(.insert(feed))
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
