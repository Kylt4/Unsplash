//
//  ProfileHeaderImageViewState.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import Foundation

@Observable
public class ProfileHeaderImageViewState: ImageViewState {
    override func load() {
        onLoad()
    }
}
