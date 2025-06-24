//
//  UIKitFeedComposer.swift
//  UnsplashApp
//
//  Created by Christophe Bugnon on 27/01/2023.
//

import UIKit
import Combine
import UnsplashFeed
import UnsplashFeediOS

@MainActor
public final class UIKitFeedComposer {
    private init() {}

    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewAdapter>

    public static func feedComposedWith(
        feedLoader: @escaping () -> AnyPublisher<Paginated<FeedImage>, Error>,
        imageLoader: @escaping (URL) -> ImageDataLoader.Publisher,
        selection: @escaping (FeedImage) -> Void
    ) -> ListViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: feedLoader)

        let feedController = makeFeedViewController(title: FeedPresenter.title)
        feedController.onRefresh = presentationAdapter.loadResource

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(controller: feedController,
                                          imageLoader: imageLoader,
                                          selection: selection),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController))

        return feedController
    }

    private static func makeFeedViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyBoard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyBoard.instantiateInitialViewController() as! ListViewController
        feedController.title = title
        return feedController
    }
}
