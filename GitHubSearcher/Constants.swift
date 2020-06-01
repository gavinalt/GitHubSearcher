import Foundation

enum ApiEndPts {
    static let userSearchUrl = "https://api.github.com/search/users"
    static let userUrl = "https://api.github.com/users/"
    static let userRepos = "https://api.github.com/users/{user}/repos"
}

enum Environment {
    static let apiStandard = "application/vnd.github.v3+json"
    static let apiToken = "token {GitHub Token}"
}
