//
//  ImageView.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI

public struct ImageView: View {
    var state: ImageViewState

    init(state: ImageViewState) {
        self.state = state
    }

    public var body: some View {
        RoundedSquareImage(image: state.image,
                           isLoading: state.isLoading)
        .overlay {
            if state.error != nil {
                Button {
                    state.load()
                } label: {
                    Image(systemName: "arrow.trianglehead.counterclockwise")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.3))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(16)
        .task(state.load)
    }
}

