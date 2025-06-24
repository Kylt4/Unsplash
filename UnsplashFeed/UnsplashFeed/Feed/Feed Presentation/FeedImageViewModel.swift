//
//  FeedImageViewModel.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 27/01/2023.
//

import Foundation

public struct FeedImageViewModel {
    public let profile: FeedProfileImageViewModel
    public let imageURL: URL
    public let description: String?
    public let likes: String?
    
    public var hasLikes: Bool {
        return likes != nil
    }

    public var hasDescription: Bool {
        return description != nil
    }
    
    public init(profile: FeedProfileImageViewModel, imageURL: URL, description: String?, likes: String?) {
        self.profile = profile
        self.imageURL = imageURL
        self.description = description
        self.likes = likes
    }
}
