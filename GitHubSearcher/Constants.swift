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
    static let login = ""
}

enum Environment {
    static let apiStandard = "application/vnd.github.v3+json"
    static let apiToken = "token 9e3dbc0a8683e63c7b809b1d40b5932ed45f1ed2"
}
