//
//  ProfileImageItem.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 23/07/2024.
//

import Foundation

public struct ProfileImageItem {
    public let username: String
    public let firstname: String
    public let url: URL

    public init(username: String, firstname: String, url: URL) {
        self.username = username
        self.firstname = firstname
        self.url = url
    }
}
