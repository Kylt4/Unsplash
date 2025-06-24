//
//  FeedImageViewHeaderContainer.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 22/07/2024.
//

import UIKit
import UnsplashFeed

class FeedImageViewHeaderContainer: UICollectionReusableView {
    let feedImageView = FeedImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        feedImageView.imageContainer.backgroundColor = .lightGray

        feedImageView.profileContainer.isHidden = true
        feedImageView.descriptionLabel.isHidden = true
        feedImageView.likesContainer.isHidden = true

        feedImageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(feedImageView)
        feedImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        feedImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        feedImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        feedImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
