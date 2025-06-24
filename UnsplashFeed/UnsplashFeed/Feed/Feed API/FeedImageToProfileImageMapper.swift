//
//  FeedImageToProfileImageMapper.swift
//  UnsplashApp
//
//  Created by Christophe Bugnon on 23/07/2024.
//

import Foundation

struct FeedImageToProfileImageMapper {
    private init() {}
    
    static func map(_ image: FeedImage) -> ProfileImageItem {
        return ProfileImageItem(
            username: image.profile.username,
            firstname: image.profile.name,
            url: image.imageURL)
    }
}
