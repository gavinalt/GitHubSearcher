//
//  Constants.swift
//  GitHubSearcher
//
//  Created by Gavin Li on 6/1/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

enum ApiEndPts {
    static let userSearchUrl = "https://api.github.com/search/users"
    static let userUrl = "https://api.github.com/users/"
    static let userRepos = "https://api.github.com/users/{user}/repos"
}

enum Environment {
    static let apiStandard = "application/vnd.github.v3+json"
    static let apiToken = "token e852a84955f9163606"
    static let token2 = "fe815901cd1f7e4bd73f71"
    static func getApiToken() -> String {
        return "\(apiToken)\(token2)"
    }
}
