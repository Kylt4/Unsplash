//
//  ErrorView.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI

struct SwiftUIErrorView: View {
    let errorMessage: String
    let onRetry: () -> Void
    
    @State private var errorIsVisible = false

    var body: some View {
        Text(errorMessage)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: errorIsVisible ? 80 : 0)
            .background(.red)
            .padding(.top)
            .opacity(errorIsVisible ? 1 : 0)
            .animation(.easeInOut(duration: 0.3), value: errorIsVisible)
            .onAppear { errorIsVisible = true }
            .onTapGesture(perform: onRetry)
    }
}
