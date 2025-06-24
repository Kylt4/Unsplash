//
//  ImageModelViewState.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI
import UnsplashFeed

@Observable
public class ImageModelViewState<Model>: ImageViewState {
    var model: Model

    public init(model: Model, onLoad: @escaping () -> Void, onSelect: @escaping () -> Void = {}) {
        self.model = model
        super.init(onLoad: onLoad, onSelect: onSelect)
    }
}
