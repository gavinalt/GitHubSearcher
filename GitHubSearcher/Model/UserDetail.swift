//
//  UserDetail.swift
//  GitHubSearcher
//
//  Created by Gavin Li on 5/31/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

struct UserDetail: Codable {
    let userId: String
    let avatarUrl: String
    let name: String?
    let email: String?
    let location: String?
    let joinDate: String
    let followerCount: Int
    let followingCount: Int
    let repoCount: Int
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case userId = "login"
        case avatarUrl = "avatar_url"
        case name
        case email
        case location
        case joinDate = "created_at"
        case followerCount = "followers"
        case followingCount = "following"
        case repoCount = "public_repos"
        case bio
    }
}
