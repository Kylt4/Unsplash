//
//  LocalFeedImage.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 26/06/2025.
//

import Foundation

public struct LocalFeedImage: Equatable, Hashable, Sendable {
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

public struct LocalFeedProfile: Equatable, Hashable, Sendable {
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
