import Foundation

struct UserDetailViewModel {
    let userDetail: UserDetail

    init(userDetail: UserDetail) {
        self.userDetail = userDetail
    }

    func getUserName() -> String {
        return userDetail.name ?? "No Name"
    }

    func getEmail() -> String {
        return userDetail.email ?? "No Email"
    }

    func getLocation() -> String {
        return userDetail.location ?? "No Location"
    }

    func getJoinDate() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-DD'T'HH:MM:SSZ"
        if let date = dateFormater.date(from: userDetail.joinDate) {
            dateFormater.dateStyle = .medium
            dateFormater.timeStyle = .none
            return dateFormater.string(from: date)
        } else {
            return "No Join Date"
        }
    }

    func getFollowers() -> String {
        return "\(userDetail.followerCount) Followers"
    }

    func getFollowing() -> String {
        return "Following \(userDetail.followingCount)"
    }

    func getAvatarUrl() -> String {
        return userDetail.avatarUrl
    }

    func getBio() -> String {
        return userDetail.bio ?? "No Bio"
    }
}
