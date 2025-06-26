//
//  FeedViewState.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI
import UnsplashFeed

@MainActor
@Observable
public class FeedViewState: ResourceView, ResourceErrorView, ResourceLoadingView {
    public typealias ResourceViewModel = [FeedImageStateContainer]
    var models: ResourceViewModel
    var error: String?
    private var isLoading: Bool = false
    private var canLoadMore = true
    var shouldShowLoader: Bool {
        return isLoading && models.isEmpty
    }

    let onLoad: () -> Void
    let onLoadMore: () -> Void

    public init(onLoad: @escaping () -> Void, onLoadMore: @escaping () -> Void) {
        self.onLoad = onLoad
        self.onLoadMore = onLoadMore
        self.models = []
    }

    public func display(_ viewModel: ResourceViewModel) {
        models.append(contentsOf: viewModel)
        canLoadMore = true
    }

    public func display(_ viewModel: UnsplashFeed.ResourceLoadingViewModel) {
        isLoading = viewModel.isLoading
    }

    public func display(_ viewModel: ResourceErrorViewModel) {
        error = viewModel.message
    }

    func load() {
        onLoad()
    }

    func loadMore() {
        guard canLoadMore else { return }
        canLoadMore = false
        onLoadMore()
    }
}
