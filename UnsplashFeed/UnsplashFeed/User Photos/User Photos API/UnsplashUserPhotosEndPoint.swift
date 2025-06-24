//
//  UnsplashUserPhotosEndPoint.swift
//  UnsplashFeed
//
//  Created by Christophe on 12/07/2023.
//

import Foundation

public enum UnsplashUserPhotosEndPoint {
    case profile(username: String)

    public func url(baseURL: URL) -> URL {
        switch self {
        case .profile(let username):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "users/\(username)/photos"
            components.queryItems = [
                URLQueryItem(name: "per_page", value: String(50)),
            ]
            return components.url!
        }
    }
}
