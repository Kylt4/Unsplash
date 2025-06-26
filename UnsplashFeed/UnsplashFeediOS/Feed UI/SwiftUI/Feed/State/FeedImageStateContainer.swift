//
//  FeedImageStateContainer.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI
import UnsplashFeed

public typealias FeedProfileViewState = ImageModelViewState<FeedProfileImageViewModel>
public typealias FeedImageViewState = ImageModelViewState<FeedImageViewModel>

@MainActor
@Observable
public class FeedImageStateContainer: Identifiable {
    public let id = UUID()
    var profile: ImageModelViewState<FeedProfileImageViewModel>
    var image: ImageModelViewState<FeedImageViewModel>

    private let selection: () -> Void

    public init(feedProfile: FeedProfileViewState,
                feedImage: FeedImageViewState,
                selection: @escaping () -> Void) {
        self.profile = feedProfile
        self.image = feedImage
        self.selection = selection
    }

    func select() {
        selection()
    }

    func load() {
        profile.load()
        image.load()
    }
}
