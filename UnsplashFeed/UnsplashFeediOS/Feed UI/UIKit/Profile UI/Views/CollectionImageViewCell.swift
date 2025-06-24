//
//  CollectionImageViewCell.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 22/07/2024.
//

import UIKit
import UnsplashFeed

public class CollectionImageViewCell: UICollectionViewCell {
    let imageView: UIImageView

    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)

        layer.cornerRadius = 8
        clipsToBounds = true

        contentView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
    }
}
