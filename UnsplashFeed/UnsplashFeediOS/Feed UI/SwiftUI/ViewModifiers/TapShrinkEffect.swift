//
//  TapShrinkEffect.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI

struct TapShrinkEffect: ViewModifier {
    @State var isTapped = false

    let onTap: () -> Void

    func body(content: Content) -> some View {
        content
            .scaleEffect(isTapped ? 0.95 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: isTapped)
            .onChange(of: isTapped) { (oldValue, newValue) in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        isTapped = false
                    })
                }
            }
            .onTapGesture {
                isTapped = true
                onTap()
            }
    }
}

extension View {
    func tapShrinkEffect(onTap: @escaping () -> Void) -> some View {
        self.modifier(TapShrinkEffect(onTap: onTap))
    }
}
