//
//  SwiftUIFeedComposer.swift
//  UnsplashApp
//
//  Created by Christophe Bugnon on 22/06/2025.
//

import SwiftUI
import UIKit
import UnsplashFeed
import UnsplashFeediOS
import Combine

@MainActor
public final class SwiftUIFeedComposer {
    private init() {}

    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewState>
    private typealias ProfileProfileImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, FeedProfileViewState>
    private typealias ProfileImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, FeedImageViewState>
    private typealias LoadMorePresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewState>

    private static var loadMoreAdapter: LoadMorePresentationAdapter?

    public static func feedComposedWith(
        feedLoader: @escaping () -> AnyPublisher<Paginated<FeedImage>, Error>,
        imageLoader: @escaping (URL) -> ImageDataLoader.Publisher,
        selection: @escaping (FeedImage) -> Void
    ) -> UIViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: feedLoader)
        let state = FeedViewState(
            onLoad: presentationAdapter.loadResource,
            onLoadMore: { loadMoreAdapter?.loadResource() }
        )

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: state,
            loadingView: state,
            errorView: state,
            mapper: recursiveMapper(state: state,
                                    imageLoader: imageLoader,
                                    selection: selection)
        )

        return UIHostingController(
            rootView: FeedView(
                state: state)
        )
    }

    private static func makeViewState(
        for item: FeedImage,
        imageLoader: @escaping (URL) -> ImageDataLoader.Publisher,
        selection: @escaping (FeedImage) -> Void
    ) -> FeedImageStateContainer {
        let viewModel = FeedImagePresenter.map(item)
        return FeedImageStateContainer(
            feedProfile: makeProfileState(
                model: viewModel.profile,
                imageLoader: imageLoader),
            feedImage: makeImageState(
                model: viewModel,
                imageLoader: imageLoader),
            selection: { selection(item) }
        )
    }

    private static func makeProfileState(model: FeedProfileImageViewModel, imageLoader: @escaping (URL) -> ImageDataLoader.Publisher) -> FeedProfileViewState {
        let presentationAdapter = ProfileProfileImageDataPresentationAdapter(loader: { [imageLoader] in
            imageLoader(model.imageURL)
        })
        let state = FeedProfileViewState(
            model: model,
            onLoad: presentationAdapter.loadResource)

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: state,
            loadingView: state,
            errorView: state,
            mapper: UIImage.tryMake(data:))
        return state
    }

    private static func makeImageState(model: FeedImageViewModel, imageLoader: @escaping (URL) -> ImageDataLoader.Publisher) -> FeedImageViewState {
        let presentationAdapter = ProfileImageDataPresentationAdapter(loader: { [imageLoader] in
            imageLoader(model.imageURL)
        })
        let state = FeedImageViewState(
            model: model,
            onLoad: presentationAdapter.loadResource)

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: state,
            loadingView: state,
            errorView: state,
            mapper: UIImage.tryMake(data:))
        return state
    }

    private static func recursiveMapper(
        state: FeedViewState,
        imageLoader: @escaping (URL) -> ImageDataLoader.Publisher,
        selection: @escaping (FeedImage) -> Void
    ) -> (Paginated<FeedImage>) -> [FeedImageStateContainer] {

        return { page in
            if let loader = page.loadMorePublisher {
                let adapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewState>(loader: loader)
                loadMoreAdapter = adapter
                adapter.presenter = LoadResourcePresenter(
                    resourceView: state,
                    loadingView: state,
                    errorView: state,
                    mapper: recursiveMapper(state: state,
                                            imageLoader: imageLoader,
                                            selection: selection)
                )
            }

            return page.items.map { image in
                makeViewState(for: image,
                              imageLoader: imageLoader,
                                selection: selection)
            }
        }
    }
}
