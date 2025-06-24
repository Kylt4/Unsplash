//
//  ProfileViewController.swift
//  UnsplashFeediOS
//
//  Created by Christophe on 31/08/2023.
//

import UIKit
import UnsplashFeed

@MainActor
public protocol ProfileViewControllerDelegate {
    func didRequestImages()
}

public final class ProfileViewController: UIViewController {
    public typealias ResourceViewModel = ProfileImagesViewModel

    private struct Constants {
        static let headerIdentifier = "CollectionHeaderCell"
        static let numberOfItemPerRow: CGFloat = 3
        static let padding: CGFloat = 5
    }

    private let collectionView: UICollectionView
    private let feedImageController: FeedImageViewHeaderController
    private let delegate: ProfileViewControllerDelegate
    private var cellControllers = [CollectionImageViewCellController]()

    public init(feedImageController: FeedImageViewHeaderController,
                delegate: ProfileViewControllerDelegate) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.feedImageController = feedImageController
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionImageViewCell.self, forCellWithReuseIdentifier: CollectionImageViewCellController.Constants.cellIdentifier)
        collectionView.register(FeedImageViewHeaderContainer.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.headerIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate.didRequestImages()
        view.backgroundColor = .white

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    public func display(controllers: [CollectionImageViewCellController]) {
        self.cellControllers = controllers
        collectionView.reloadData()
    }

    private func cellController(for indexPath: IndexPath) -> CollectionImageViewCellController {
        return cellControllers[indexPath.row]
    }
}

extension ProfileViewController: ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: ResourceLoadingViewModel) {}

    public func display(_ viewModel: ResourceErrorViewModel) {}
}


extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - Header

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let cell = feedImageController.cell {
            feedImageController.didDisplayCell()
            return cell
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.headerIdentifier, for: indexPath) as! FeedImageViewHeaderContainer
        view.frame.size = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width)
        feedImageController.cell = view
        feedImageController.didDisplayCell()
        return view
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionHeader {
            feedImageController.didEndDisplayCell()
        }
    }

    // MARK: - UICollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.setContentOffset(.zero,
                                        animated: true)
        let image = cellController(for: indexPath).getImage()
        image.map(feedImageController.display(_:))
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cellController(for: indexPath).collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cellController(for: indexPath).collectionView(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: Constants.padding, bottom: 0, right: Constants.padding)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s = collectionView.bounds.size
        let w = (s.width/Constants.numberOfItemPerRow) - (Constants.padding * 2)
        return CGSize(width: w, height: w)
    }

    // MARK: - UICollectionViewDataSource

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellControllers.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellController(for: indexPath).collectionView(collectionView, cellForItemAt: indexPath)
    }
}
