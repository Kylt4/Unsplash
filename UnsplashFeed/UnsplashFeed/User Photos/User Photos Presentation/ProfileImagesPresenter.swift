//
//  ProfileImagesPresenter.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 23/07/2024.
//

import Foundation

public final class ProfileImagesPresenter {
    public static func map(_ photos: ProfileImagesItem) -> ProfileImagesViewModel {
        return ProfileImagesViewModel(urls: photos.urls)
    }
}

