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
