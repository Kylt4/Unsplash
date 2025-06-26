//
//  FeedImage.swift
//  WeMomsFeed
//
//  Created by Christophe Bugnon on 20/08/2022.
//

import Foundation

public struct FeedImage: Equatable, Hashable, Sendable {
    public let id: String
    public let title: String?
    public let imageURL: URL
    public let likes: Int
    public let profile: FeedProfile

    public init(id: String, title: String?, imageURL: URL, likes: Int, profile: FeedProfile) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.likes = likes
        self.profile = profile
    }
}
