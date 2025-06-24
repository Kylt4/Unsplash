//
//  ProfileImagesViewModel.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 22/07/2024.
//

import Foundation

public struct ProfileImagesViewModel {
    public let urls: [URL]

    public init(urls: [URL]) {
        self.urls = urls
    }
}
