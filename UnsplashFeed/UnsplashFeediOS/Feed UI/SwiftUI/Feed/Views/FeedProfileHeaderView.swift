//
//  FeedProfileHeaderView.swift
//  UnsplashFeed
//
//  Created by Christophe Bugnon on 23/06/2025.
//

import SwiftUI

struct FeedProfileHeaderView: View {
    var state: FeedProfileViewState

    var body: some View {
        HStack {
            ImageView(state: state)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(state.model.firstname)
                    .font(.system(size: 16, weight: .semibold))
                Text(state.model.username)
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(Color(UIColor.lightGray))
            }
            Spacer()
        }

    }
}
