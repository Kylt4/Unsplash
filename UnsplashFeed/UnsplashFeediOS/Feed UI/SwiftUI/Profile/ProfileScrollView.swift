//
//  ProfileScrollView.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI

struct ProfileScrollView: View {
    var state: ProfileImageStateContainer
    let onImageTap: (ImageViewState) -> Void

    let columnCount: Int = 3
    let gridSpacing: CGFloat = 8

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    headerContent
                        .padding(.horizontal, 8)
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: gridSpacing), count: columnCount), spacing: gridSpacing) {
                        gridView(proxy: proxy)
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }

    @ViewBuilder
    var headerContent: some View {
        Color.clear
            .frame(height: 0)
            .id("top")
        ImageView(state: state.header)
    }

    @ViewBuilder
    func gridView(proxy: ScrollViewProxy) -> some View {
        ForEach(state.images.indices, id: \.self, content: { index in
            let state = state.images[index]
            ImageView(state: state)
                .tapShrinkEffect {
                    onImageTap(state)
                    withAnimation {
                        proxy.scrollTo("top", anchor: .top)
                    }
                }
        })
    }
}
