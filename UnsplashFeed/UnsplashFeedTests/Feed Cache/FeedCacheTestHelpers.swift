//
//  FeedCacheTestHelpers.swift
//  UnsplashFeedTests
//
//  Created by Christophe Bugnon on 26/06/2025.
//

import Foundation
import UnsplashFeed

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
