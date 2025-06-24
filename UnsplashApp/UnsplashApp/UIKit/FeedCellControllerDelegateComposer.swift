//
//  FeedCellControllerDelegateComposer.swift
//  UnsplashApp
//
//  Created by Christophe Bugnon on 27/01/2023.
//

import Foundation
import UnsplashFeediOS

final class FeedCellControllerDelegateComposer: FeedImageCellControllerDelegate {
    var objects: [FeedImageCellControllerDelegate]

    init(objects: [FeedImageCellControllerDelegate]) {
        self.objects = objects
    }

    func didRequestImage() {
        objects.forEach { $0.didRequestImage() }
    }

    func didCancelImageRequest() {
        objects.forEach { $0.didCancelImageRequest() }
    }
}
