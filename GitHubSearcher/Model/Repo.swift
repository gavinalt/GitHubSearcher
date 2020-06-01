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
