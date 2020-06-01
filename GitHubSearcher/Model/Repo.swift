//
//  Repo.swift
//  GitHubSearcher
//
//  Created by Gavin Li on 6/1/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

struct Repo: Codable {
    let name: String
    let htmlUrl: String
    let forkCount: Int
    let starCount: Int

    enum CodingKeys: String, CodingKey {
        case name
        case htmlUrl = "html_url"
        case forkCount = "forks_count"
        case starCount = "stargazers_count"
    }
}
