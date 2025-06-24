//
//  CollectionImageViewCellController.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 22/07/2024.
//

import UIKit
import UnsplashFeed

@MainActor
public final class CollectionImageViewCellController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    struct Constants {
        static let cellIdentifier = "CollectionImageCell"
    }
    public typealias ResourceViewModel = UIImage

    private let delegate: FeedImageCellControllerDelegate
    private(set) weak var cell: CollectionImageViewCell?
    private var hasBeenDisplayed = false
    private var image: UIImage?

    public init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }

    func getImage() -> UIImage? {
        return image
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! CollectionImageViewCell
        cell.backgroundColor = .systemGray6
        self.cell = cell
        image.map(display)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard image == nil else { return }
        delegate.didRequestImage()
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cancelLoad()
    }

    private func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }

    private func releaseCellForReuse() {
        cell = nil
    }
}

extension CollectionImageViewCellController: ResourceView, ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: UIImage) {
        image = viewModel

        if hasBeenDisplayed {
            cell?.imageView.image = viewModel
        } else {
            hasBeenDisplayed = true
            cell?.imageView.setImageAnimated(viewModel)
        }
    }

    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.isShimmering = viewModel.isLoading
    }

    public func display(_ viewModel: ResourceErrorViewModel) {}
}

