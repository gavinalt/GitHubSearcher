import UIKit

class SearcherTableCell: UITableViewCell {

    var avatar: Avatar
    var userId: TableCellLabel
    var repoCount: TableCellLabel

    let queryService = QueryService.init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        avatar = Avatar.init(frame: .zero)
        userId = TableCellLabel.init(frame: .zero)
        repoCount = TableCellLabel.init(frame: .zero)
        repoCount.setPrefix("Repo: ")

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .systemBackground
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.image = nil
        userId.setText("")
        repoCount.setText("")
    }

    private func setupSubview() {
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(userId)
        self.contentView.addSubview(repoCount)

        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            avatar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            avatar.widthAnchor.constraint(equalTo: avatar.heightAnchor),

            userId.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            userId.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            repoCount.leadingAnchor.constraint(greaterThanOrEqualTo: userId.trailingAnchor, constant: 16),
            repoCount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            repoCount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        repoCount.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func configureCell(basedOn user: User) {
        avatar.startDownload(from: user.avatarUrl)
        userId.setText("\(user.userId)")
        queryService.getUserDetail(userId: user.userId) { [weak self] (userDetail, errorMsg) in
            DispatchQueue.main.async {
                let count = userDetail?.repoCount ?? 0
                self?.repoCount.setText("\(count)")
            }
        }
    }
}
