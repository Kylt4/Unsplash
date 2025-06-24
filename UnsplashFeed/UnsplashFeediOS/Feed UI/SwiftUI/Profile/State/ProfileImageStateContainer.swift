//
//  ProfileImageStateContainer.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import Foundation

@Observable
public class ProfileImageStateContainer {
    let header: ImageViewState
    let images: [ImageViewState]

    public init(header: ImageViewState, images: [ImageViewState]) {
        self.header = header
        self.images = images
    }
}
