//
//  FeedProfile.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import Foundation

public struct FeedProfile: Equatable, Hashable, Sendable {
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
