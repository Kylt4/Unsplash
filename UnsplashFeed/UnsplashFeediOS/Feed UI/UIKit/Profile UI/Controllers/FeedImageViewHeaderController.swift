//
//  FeedImageViewHeaderController.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 22/07/2024.
//

import UIKit
import UnsplashFeed

public class FeedImageViewHeaderController: NSObject, ResourceView, ResourceLoadingView, ResourceErrorView {
    public typealias ResourceViewModel = UIImage

    private let delegate: FeedImageCellControllerDelegate
    weak var cell: FeedImageViewHeaderContainer?
    var image: UIImage?
    private var hasBeenSeen = false

    public init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }

    func didDisplayCell() {
        if let image {
            cell?.feedImageView.imageView.image = image
            cell?.isShimmering = false
        } else {
            delegate.didRequestImage()
        }
    }

    func didEndDisplayCell() {
        cell = nil
        delegate.didCancelImageRequest()
    }

    public func display(_ viewModel: UIImage) {
        image = viewModel
        
        if hasBeenSeen {
            cell?.feedImageView.imageView.image = viewModel
        } else {
            hasBeenSeen = true
            cell?.feedImageView.imageView.setImageAnimated(viewModel)
        }
    }

    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.isShimmering = viewModel.isLoading
    }

    public func display(_ viewModel: ResourceErrorViewModel) {
        cell?.feedImageView.imageRetryButton.isHidden = viewModel.message == nil
    }
}
