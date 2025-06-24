//
//  FeedImageView.swift
//  Xib-test
//
//  Created by Christophe on 11/07/2023.
//

import UIKit
import UnsplashFeed

class FeedImageView: XIBView {
    @IBOutlet private(set) var profileContainer: UIView!
    @IBOutlet private(set) var profileImageView: UIImageView!
    @IBOutlet private(set) var profileFirstnameLabel: UILabel!
    @IBOutlet private(set) var profileUsernameLabel: UILabel!
    @IBOutlet private(set) var imageContainer: UIView!
    @IBOutlet private(set) var imageRetryButton: UIButton!
    @IBOutlet private(set) var imageView: UIImageView!
    @IBOutlet private(set) var descriptionLabel: UILabel!
    @IBOutlet private(set) var likesContainer: UIStackView!
    @IBOutlet private(set) var likesLabel: UILabel!
    
    func configure(viewModel: FeedImageViewModel) {
        imageRetryButton.isHidden = true
        likesContainer.isHidden = !viewModel.hasLikes
        descriptionLabel.isHidden = !viewModel.hasDescription
        profileFirstnameLabel.text = viewModel.profile.username
        profileFirstnameLabel.text = viewModel.profile.firstname
        descriptionLabel.text = viewModel.description
        likesLabel.text = viewModel.likes
    }

}
