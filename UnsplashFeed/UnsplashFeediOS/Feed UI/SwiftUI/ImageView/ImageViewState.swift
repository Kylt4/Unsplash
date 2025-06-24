//
//  ImageViewState.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI
import UnsplashFeed

@Observable
public class ImageViewState: ResourceView, ResourceErrorView, ResourceLoadingView {
    public typealias ResourceViewModel = UIImage
    var image: UIImage?
    var error: String?
    var isLoading: Bool = false

    var onLoad: () -> Void
    var onSelect: () -> Void

    public init(onLoad: @escaping () -> Void, onSelect: @escaping () -> Void = {}) {
        self.onLoad = onLoad
        self.onSelect = onSelect
    }

    public func display(_ viewModel: UIImage) {
        image = viewModel
    }

    public func display(_ viewModel: UnsplashFeed.ResourceErrorViewModel) {
        error = viewModel.message
    }

    public func display(_ viewModel: UnsplashFeed.ResourceLoadingViewModel) {
        isLoading = viewModel.isLoading
    }

    func select() {
        onSelect()
    }

    func load() {
        onLoad()
    }
}
