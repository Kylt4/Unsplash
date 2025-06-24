//
//  UnsplashEndPoint.swift
//  WeMomsApp
//
//  Created by Christophe Bugnon on 03/11/2022.
//

import Foundation

public enum UnsplashFeedEndPoint {
    case photos(page: Int)

    public func url(baseURL: URL) -> URL {
        switch self {
        case .photos(let page):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "photos"
            components.queryItems = [
                URLQueryItem(name: "page", value: String(page)),
            ]
            return components.url!
        }
    }
}
