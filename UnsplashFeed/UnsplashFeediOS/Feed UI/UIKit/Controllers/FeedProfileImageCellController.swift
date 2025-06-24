//
//  FeedProfileImageCellController.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 27/01/2023.
//

import UIKit
import UnsplashFeed

@MainActor
public final class FeedProfileImageCellController: NSObject {
    public typealias ResourceViewModel = UIImage

    weak var imageView: UIImageView?
}

extension FeedProfileImageCellController: ResourceLoadingView, ResourceErrorView, ResourceView {

    public func display(_ viewModel: UIImage) {
        imageView?.image = viewModel
    }

    public func display(_ viewModel: ResourceLoadingViewModel) {
        imageView?.isShimmering = viewModel.isLoading
    }

    public func display(_ viewModel: ResourceErrorViewModel) {}
}
