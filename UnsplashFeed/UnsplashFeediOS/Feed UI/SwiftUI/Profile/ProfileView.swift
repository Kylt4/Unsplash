//
//  ProfileView.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI

public struct ProfileView: View {
    var state: ProfileViewState

    public init(state: ProfileViewState) {
        self.state = state
    }

    public var body: some View {
        content
            .onAppear(perform: state.load)
    }

    @ViewBuilder
    private var content: some View {
        if state.isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let model = state.model {
            ProfileScrollView(state: model, onImageTap: { imageState in
                state.updateHeader(from: imageState)
            })
        } else if let error = state.error {
            VStack {
                SwiftUIErrorView(errorMessage: error, onRetry: state.load)
                Spacer()
            }
        }
    }
}
