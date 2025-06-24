//
//  FeedContainerImageView.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI

struct FeedContainerImageView: View {
    var state: FeedImageViewState

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ImageView(state: state)
            if state.model.hasDescription {
                Text(state.model.description!)
            }
            if let likes = state.model.likes {
                HStack(spacing: 8) {
                    Text("💛")
                    Text(likes)
                        .font(.system(size: 17, weight:. semibold))
                    Spacer()
                }
            }
        }
    }
}
