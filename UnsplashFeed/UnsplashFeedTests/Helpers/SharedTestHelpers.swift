//
//  SharedTestHelpers.swift
//  UnsplashFeedTests
//
//  Created by Christophe Bugnon on 26/06/2025.
//

import Foundation

func waitForContinuation() async {
    try? await Task.sleep(nanoseconds: 1_000_000)
}
