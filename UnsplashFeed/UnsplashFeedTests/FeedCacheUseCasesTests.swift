//
//  FeedCacheUseCasesTests.swift
//  UnsplashFeedTests
//
//  Created by Christophe Bugnon on 26/06/2025.
//

import Foundation
import XCTest
import UnsplashFeed

public struct LocalFeedImage: Equatable, Hashable {
    public let id: String
    public let title: String?
    public let imageURL: URL
    public let likes: Int
    public let profile: LocalFeedProfile

    public init(id: String, title: String?, imageURL: URL, likes: Int, profile: LocalFeedProfile) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.likes = likes
        self.profile = profile
    }
}

public struct LocalFeedProfile: Equatable, Hashable {
    public let id: String
    public let name: String
    public let username: String
    public let imageURL: URL

    public init(id: String, name: String, username: String, imageURL: URL) {
        self.id = id
        self.name = name
        self.username = username
        self.imageURL = imageURL
    }
}

final class LocalFeedCache: @unchecked Sendable {
    private let store: FeedStore

    init(store: FeedStore) {
        self.store = store
    }

    func save(_ feed: [FeedImage]) async throws {
        try await store.deleteCachedFeed()
        try await store.insert(feed.map(\.toLocal))
    }
}

extension FeedImage {
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

class FeedStore: @unchecked Sendable {
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

        Task { try await sut.save([]) }
        await store.completeDeletionWithError(deletionError)

        XCTAssertEqual(store.messages, [.deleteCachedFeed])
    }

    func test_save_requestFeedInsertionOnSucessfulDeletion() async {
        let store = FeedStore()
        let sut = LocalFeedCache(store: store)
        let feed = uniqueFeed()

        Task { try await sut.save(feed) }
        await store.completeDeletionSuccessfully()
        await store.completeInsertionSuccessfully()

        XCTAssertEqual(store.messages, [.deleteCachedFeed, .insert(feed.map(\.toLocal))])
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
                feed: [FeedImage],
                toCompleteWith expectedMessages: [FeedStore.ReceivedMessage],
                when action: () async -> Void,
                file: StaticString = #filePath,
                line: UInt = #line) async {

        Task { [weak sut] in try await sut?.save([]) }

        try? await Task.sleep(nanoseconds: 1_000_000)
        await action()

        XCTAssertEqual(store.messages, expectedMessages, file: file, line: line)
    }

    func expect(_ sut: LocalFeedCache,
                toCompleteWith expectedError: Error?,
                when action: () async -> Void,
                file: StaticString = #filePath,
                line: UInt = #line) async {

        let task = Task { try await sut.save([]) }

        await action()

        var receivedError: Error?
        do {
            try await task.value
        } catch {
            receivedError = error
        }

        XCTAssertEqual(receivedError as? NSError, expectedError as? NSError, file: file, line: line)
    }

    func uniqueImageFeed() -> FeedImage {
        return FeedImage(id: UUID().uuidString,
                         title: "any title",
                         imageURL: URL(string: "http://any-image-url.com")!,
                         likes: Int.random(in: 0...100),
                         profile: FeedProfile(
                            id: UUID().uuidString,
                            name: "any name",
                            username: "any username",
                            imageURL: URL(string: "http://any-image-url.com")!))
    }

    func uniqueFeed() -> [FeedImage] {
        return [uniqueImageFeed(), uniqueImageFeed()]
    }
}
