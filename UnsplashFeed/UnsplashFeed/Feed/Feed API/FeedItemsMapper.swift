//
//  FeedItemsMapper.swift
//  WeMomsFeed
//
//  Created by Christophe Bugnon on 20/08/2022.
//

import Foundation

public struct FeedItemsMapper {
    struct User: Decodable {
        let id: String
        let name: String
        let username: String
        let imageURL: URL
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case username
            case imageURL = "profile_image"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(String.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            username = try container.decode(String.self, forKey: .username)
            let urls = try container.decode([String: URL].self, forKey: .imageURL)
            imageURL = urls["medium"]!
        }
    }
    
    struct Image: Decodable {
        let id: String
        let description: String?
        let imageURL: URL
        let user: User
        let likes: Int
        
        var item: FeedImage {
            return FeedImage(id: id,
                             title: description,
                             imageURL: imageURL,
                             likes: likes,
                             profile: FeedProfile(id: user.id,
                                                    name: user.name,
                                                    username: user.username,
                                                    imageURL: user.imageURL))
        }
        
        enum CodingKeys: String, CodingKey {
            case id
            case description
            case urls
            case user
            case likes
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(String.self, forKey: .id)
            description = try container.decodeIfPresent(String.self, forKey: .description)
            let urls = try container.decode([String: URL].self, forKey: .urls)
            imageURL = urls["regular"]!
            user = try container.decode(User.self, forKey: .user)
            likes = try container.decode(Int.self, forKey: .likes)
        }
    }

    enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, response: HTTPURLResponse) throws -> [FeedImage] {
        guard response.statusCode == 200,
                let images = try? JSONDecoder().decode([Image].self, from: data) else {
            throw Error.invalidData
        }
        return images.map(\.item)
    }
}
