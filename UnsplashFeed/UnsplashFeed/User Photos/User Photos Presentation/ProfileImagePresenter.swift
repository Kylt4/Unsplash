//
//  ProfileImagePresenter.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 23/07/2024.
//

import Foundation

public struct ProfileImagePresenter {
    public static func map(_ image: ProfileImageItem) -> ProfileImageViewModel {
        return ProfileImageViewModel(username: image.username, firstname: image.firstname, url: image.url)
    }
}
