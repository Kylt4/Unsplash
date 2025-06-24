//
//  FeedImageCell.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 27/01/2023.
//

import UIKit
import UnsplashFeed

public final class FeedImageCell: UITableViewCell {
    @IBOutlet weak var feedImageView: FeedImageView!
    
    var onRetry: (() -> Void)?

    public override func layoutSubviews() {
        super.layoutSubviews()

        configureShadow()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        
        feedImageView.imageView.image = nil
        feedImageView.imageRetryButton.isHidden = true
    }

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: 0.25, animations: {
            self.feedImageView.layer.shadowOpacity = highlighted ? 0.5 : 0.2
        })
    }

    func configure(viewModel: FeedImageViewModel) {
        feedImageView.configure(viewModel: viewModel)
    }

    private func configureShadow() {
        feedImageView.layer.cornerRadius = 22
        feedImageView.layer.shadowColor = UIColor.black.cgColor
        feedImageView.layer.shadowOffset = .zero
        feedImageView.layer.shadowRadius = 6
        feedImageView.layer.shadowOpacity = 0.2
    }

    @IBAction private func retryButtonTapped() {
        onRetry?()
    }
}
