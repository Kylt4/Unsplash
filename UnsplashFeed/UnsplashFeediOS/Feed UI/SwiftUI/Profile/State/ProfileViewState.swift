//
//  ProfileViewState.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI
import UnsplashFeed

@Observable
public class ProfileViewState: ResourceView, ResourceLoadingView, ResourceErrorView {
    public typealias ResourceViewModel = ProfileImageStateContainer
    var error: String?
    var isLoading: Bool = false

    var model: ProfileImageStateContainer?
    private var onLoad: () -> Void

    public init(onLoad: @escaping () -> Void) {
        self.model = nil
        self.onLoad = onLoad
    }

    public func display(_ viewModel: ProfileImageStateContainer) {
        model = viewModel
    }

    public func display(_ viewModel: ResourceLoadingViewModel) {
        isLoading = viewModel.isLoading
    }

    public func display(_ viewModel: ResourceErrorViewModel) {
        error = viewModel.message
    }

    func updateHeader(from state: ImageViewState) {
        state.select()
        model?.header.load()
    }

    func load() {
        onLoad()
    }
}
