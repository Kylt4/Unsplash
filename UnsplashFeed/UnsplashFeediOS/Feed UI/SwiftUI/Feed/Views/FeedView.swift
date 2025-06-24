//
//  FeedView.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 22/06/2025.
//

import SwiftUI
import UnsplashFeed

public struct FeedView: View {
    @State private var canLoadMore = true
    @State private var shouldLoad = true
    var state: FeedViewState

    public init(state: FeedViewState) {
        self.state = state
    }

    public var body: some View {
        VStack {
            if state.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(state.models.indices, id: \.self) { index in
                        FeedCardView(state: state.models[index])
                    }
                    if !state.models.isEmpty {
                        PaginatedLoaderView(loadMore: state.loadMore)
                        .frame(height: 50)
                    }
                }
            }
        }
        .navigationTitle("Feed")
        .navigationBarTitleDisplayMode(.automatic)
        .task {
            guard shouldLoad else { return }
            shouldLoad = false
            state.load()
        }
    }
}
