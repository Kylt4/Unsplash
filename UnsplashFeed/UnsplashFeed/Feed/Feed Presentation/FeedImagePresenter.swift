//
//  FeedImagePresenter.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 27/01/2023.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(profile: FeedProfileImageViewModel(firstname: image.profile.name,
                                                              username: image.profile.username,
                                                              imageURL: image.profile.imageURL),
                           imageURL: image.imageURL,
                           description: image.title,
                           likes: image.likes > 0 ? String(image.likes) : nil)
    }
}
