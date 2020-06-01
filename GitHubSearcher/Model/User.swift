//
//  User.swift
//  GitHubSearcher
//
//  Created by Gavin Li on 5/31/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

struct User: Codable {
    let userId: String
    let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case userId = "login"
        case avatarUrl = "avatar_url"
    }
}

struct SearchQueryResponse: Codable {
    let resultCount: Int
    let users: [User]

    enum CodingKeys: String, CodingKey {
        case resultCount = "total_count"
        case users = "items"
    }
}
