//
//  ProfileUIComposer.swift
//  UnsplashApp
//
//  Created by Christophe Bugnon on 22/07/2024.
//

import UIKit
import Combine
import UnsplashFeed
import UnsplashFeediOS

@MainActor
public final class UIKitProfileComposer {
    private init() {}

    typealias ProfileImagesDataPresentationAdapter = LoadResourcePresentationAdapter<ProfileImagesItem, ProfileViewAdapter>
    typealias FeedHeaderImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, ImageWeakRefVirtualProxy<FeedImageViewHeaderController>>

    public static func profileComposedWith(image: ProfileImageItem,
                                           userPhotosLoader: @escaping (String) -> AnyPublisher<ProfileImagesItem, Error>,
                                           imageLoader: @escaping (URL) -> ImageDataLoader.Publisher) -> ProfileViewController {
        let viewModel = ProfileImagePresenter.map(image)
        let adapter = ProfileImagesDataPresentationAdapter { [userPhotosLoader] in
            userPhotosLoader(viewModel.username)
        }

        let feedImageAdapter = FeedHeaderImageDataPresentationAdapter { [imageLoader] in
            imageLoader(viewModel.url)
        }
        let feedImageController = FeedImageViewHeaderController(delegate: feedImageAdapter)
        feedImageAdapter.presenter = LoadResourcePresenter(resourceView: ImageWeakRefVirtualProxy(feedImageController),
                                                           loadingView: ImageWeakRefVirtualProxy(feedImageController),
                                                           errorView: ImageWeakRefVirtualProxy(feedImageController),
                                                           mapper: UIImage.tryMake(data:))
        let profileVC = ProfileViewController(feedImageController: feedImageController,
                                              delegate: adapter)
        profileVC.title = viewModel.firstname
        let profileAdapter = ProfileViewAdapter(controller: profileVC,
                                                imageLoader: imageLoader)
        adapter.presenter = LoadResourcePresenter(resourceView: profileAdapter,
                                                  loadingView: WeakRefVirtualProxy(profileVC),
                                                  errorView: WeakRefVirtualProxy(profileVC),
                                                  mapper: SendableProxy.makeSendable(ProfileImagesPresenter.map(_:)))
        return profileVC
    }
}
