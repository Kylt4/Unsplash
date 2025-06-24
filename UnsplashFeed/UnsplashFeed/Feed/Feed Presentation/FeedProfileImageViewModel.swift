//
//  FeedProfileImageViewModel.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 27/01/2023.
//

import Foundation

public struct FeedProfileImageViewModel {
    public let firstname: String
    public let username: String
    public let imageURL: URL
    
    public init(firstname: String, username: String, imageURL: URL) {
        self.firstname = firstname
        self.username = username
        self.imageURL = imageURL
    }
}
