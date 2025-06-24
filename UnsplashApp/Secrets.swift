//
//  Secrets.swift
//  UnsplashApp
//
//  Created by Christophe Bugnon on 24/06/2025.
//

import Foundation

enum Secrets {
    static let apiKey: String = {
        guard let key = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            fatalError("❌ API_KEY manquante dans Info.plist")
        }
        return key
    }()
}
