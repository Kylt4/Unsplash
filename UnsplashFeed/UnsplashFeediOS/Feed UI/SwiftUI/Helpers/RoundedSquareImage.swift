//
//  RoundedSquareImage.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI

struct RoundedSquareImage: View {
    let image: UIImage?
    let isLoading: Bool
    @State private var imageIsVisible = false

    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .overlay {
                ZStack {
                    if isLoading {
                        ShimmerView()
                    } else if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .opacity(imageIsVisible ? 1 : 0)
                    }
                }
            }
            .onChange(of: image) { oldValue, newValue in
                guard !imageIsVisible else { return }
                withAnimation(.easeInOut(duration: 0.5)) {
                    imageIsVisible = true
                }
            }
    }
}


#Preview {
    RoundedSquareImage(image: nil, isLoading: true)
}
