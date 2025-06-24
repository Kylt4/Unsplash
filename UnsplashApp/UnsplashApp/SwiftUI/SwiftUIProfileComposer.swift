//
//  SwiftUIProfileComposer.swift
//  UnsplashApp
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI
import UIKit
import UnsplashFeed
import UnsplashFeediOS
import Combine

@MainActor
public final class SwiftUIProfileComposer {
    private init() {}

    typealias ProfileImagesDataPresentationAdapter = LoadResourcePresentationAdapter<ProfileImagesItem, ProfileImagesStateWeakRefVirtualProxy<ProfileViewState>>
    typealias ProfileImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, ImageWeakRefVirtualProxy<ImageViewState>>

    public static func profileComposedWith(image: ProfileImageItem,
                                           userPhotosLoader: @escaping (String) -> AnyPublisher<ProfileImagesItem, Error>,
                                           imageLoader: @escaping (URL) -> ImageDataLoader.Publisher) -> UIViewController {
        let viewModel = ProfileImagePresenter.map(image)
        let adapter = ProfileImagesDataPresentationAdapter { [userPhotosLoader] in
            userPhotosLoader(viewModel.username)
        }
        let state = ProfileViewState(onLoad: adapter.loadResource)
        adapter.presenter = LoadResourcePresenter(
            resourceView: ProfileImagesStateWeakRefVirtualProxy(state),
            loadingView: ProfileImagesStateWeakRefVirtualProxy(state),
            errorView: ProfileImagesStateWeakRefVirtualProxy(state),
            mapper: { item in
                var updateHeaderURL: URL?
                return ProfileImageStateContainer(
                    header: makeHeaderImageState(
                        imageURL: { updateHeaderURL ?? image.url },
                        imageLoader: imageLoader),
                    images: item.urls.map { url in
                        makeImageState(
                            imageURL: url,
                            imageLoader: imageLoader,
                            onSelect: { updateHeaderURL = url })
                    })
            })

        let vc = UIHostingController(rootView: ProfileView(state: state))
        vc.title = viewModel.firstname
        return vc
    }

    private static func makeHeaderImageState(imageURL: @escaping () -> URL, imageLoader: @escaping (URL) -> ImageDataLoader.Publisher) -> ImageViewState {
        let presentationAdapter = ProfileImageDataPresentationAdapter(loader: { [imageLoader] in
            imageLoader(imageURL())
        })
        let state = ProfileHeaderImageViewState(onLoad: presentationAdapter.loadResource)
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: ImageWeakRefVirtualProxy(state),
            loadingView: ImageWeakRefVirtualProxy(state),
            errorView: ImageWeakRefVirtualProxy(state),
            mapper: UIImage.tryMake(data:))
        return state
    }

    private static func makeImageState(imageURL: URL, imageLoader: @escaping (URL) -> ImageDataLoader.Publisher, onSelect: @escaping () -> Void) -> ImageViewState {
        let presentationAdapter = ProfileImageDataPresentationAdapter(loader: { [imageLoader] in
            imageLoader(imageURL)
        })
        let state = ImageViewState(onLoad: presentationAdapter.loadResource, onSelect: onSelect)

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: ImageWeakRefVirtualProxy(state),
            loadingView: ImageWeakRefVirtualProxy(state),
            errorView: ImageWeakRefVirtualProxy(state),
            mapper: UIImage.tryMakeThumbnail(data:))
        return state
    }
}

