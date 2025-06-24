//
//  FeedCardView.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 22/06/2025.
//

import SwiftUI
import UnsplashFeed

struct FeedCardView: View {
    let state: FeedImageStateContainer
    @State var isTapped = false

    @State private var isVisible = false

    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(16)
                .shadow(radius: 4)
            VStack(spacing: 16) {
                FeedProfileHeaderView(state: state.profile)
                FeedContainerImageView(state: state.image)
            }
            .padding()
        }
        .padding()
        .opacity(isVisible ? 1 : 0)
        .animation(
            .easeOut(duration: 0.3),
            value: isVisible
        )
        .tapShrinkEffect {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                state.select()
            })
        }
        .task(state.load)
        .onAppear {
            isVisible = true
        }
    }
}
