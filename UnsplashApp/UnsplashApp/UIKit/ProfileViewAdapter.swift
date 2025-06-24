//
//  ProfileViewAdapter.swift
//  UnsplashApp
//
//  Created by Christophe Bugnon on 22/07/2024.
//

import UIKit
import UnsplashFeed
import UnsplashFeediOS

final class ProfileViewAdapter: ResourceView {
    typealias ResourceViewModel = ProfileImagesViewModel

    private weak var controller: ProfileViewController?
    private let imageLoader: (URL) -> ImageDataLoader.Publisher

    private typealias CollectionImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, ImageWeakRefVirtualProxy<CollectionImageViewCellController>>

    init(controller: ProfileViewController, imageLoader: @escaping (URL) -> ImageDataLoader.Publisher) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(_ viewModel: ProfileImagesViewModel) {
        let controllers = viewModel.urls.map { imageURL in
            let adapter = CollectionImageDataPresentationAdapter {
                [imageLoader] in
                imageLoader(imageURL)
            }
            let view = CollectionImageViewCellController(delegate: adapter)
            adapter.presenter = LoadResourcePresenter(resourceView: ImageWeakRefVirtualProxy(view),
                                                      loadingView: view,
                                                      errorView: view,
                                                      mapper: UIImage.tryMake(data:))
            return view
        }
        controller?.display(controllers: controllers)
    }
}
