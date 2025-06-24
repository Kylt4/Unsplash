//
//  PaginatedLoaderView.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI

struct PaginatedLoaderView: View {
    private let loadMore: () -> Void

    init(loadMore: @escaping () -> Void) {
        self.loadMore = loadMore
    }

    var body: some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .onAppear(perform: loadMore)
    }
}
