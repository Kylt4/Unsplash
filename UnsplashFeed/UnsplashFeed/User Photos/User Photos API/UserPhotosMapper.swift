//
//  UserPhotosMapper.swift
//  UnsplashFeed
//
//  Created by Christophe on 12/07/2023.
//

import Foundation

public final class UserPhotosMapper {
    enum Error: Swift.Error {
        case invalidData
    }

    public static func map(_ data: Data, response: HTTPURLResponse) throws -> ProfileImagesItem {
        guard response.statusCode == 200,
                let images = try? JSONDecoder().decode([RemoteImage].self, from: data) else {
            throw Error.invalidData
        }
        return ProfileImagesItem(urls: images.map(\.imageURL))
    }

    private struct RemoteImage: Decodable {
        let imageURL: URL

        enum CodingKeys: String, CodingKey {
            case imageURL = "urls"
        }

        struct RegularImageURLDoesNotExist: Swift.Error {}

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let urls = try container.decode([String: URL].self, forKey: .imageURL)
            guard let regularURL = urls["regular"] else {
                throw RegularImageURLDoesNotExist()
            }
            imageURL = regularURL
        }
    }
}
