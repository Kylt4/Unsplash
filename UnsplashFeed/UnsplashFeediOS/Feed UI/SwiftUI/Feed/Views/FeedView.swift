//
//  FeedView.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 22/06/2025.
//

import SwiftUI
import UnsplashFeed

public struct FeedView: View {
    @State private var shouldLoad = true

    var state: FeedViewState

    public init(state: FeedViewState) {
        self.state = state
    }

    public var body: some View {
        VStack {
            if state.shouldShowLoader {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(state.models) { model in
                        FeedCardView(state: model)
                            .id(model.id)
                    }

                    if !state.models.isEmpty {
                        PaginatedLoaderView(loadMore: state.loadMore)
                            .frame(height: 50)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            if shouldLoad {
                shouldLoad = false
                state.load()
            }
        }
        .navigationTitle("Feed")
    }
}
