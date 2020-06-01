import UIKit
import SafariServices

class UserDetailViewController: UIViewController {

    var allRepos: [Repo] = []
    var filteredRepos: [Repo] = []

    let repoTableCellIdentifier = "repoTableCell"
    let appTitle = "GitHub Searcher"
    private var viewModel: UserDetailViewModel!
    private let queryService: QueryService

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for User's Repositories"
        searchBar.returnKeyType = .done
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let repoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 32
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    init(userId: String) {
        queryService = QueryService.init()
        super.init(nibName: nil, bundle: nil)

        queryService.getUserDetail(userId: userId) { [weak self] (userDetail, errorMsg) in
            DispatchQueue.main.async {
                if let detail = userDetail {
                    self?.viewModel = UserDetailViewModel.init(userDetail: detail)
                    self?.setupSubview()
                }
            }
        }

        queryService.getUserRepos(userId: userId) { [weak self] (repoArray, errorMsg) in
            DispatchQueue.main.async {
                if let repos = repoArray {
                    self?.allRepos = repos
                    self?.filteredRepos = repos
                    self?.repoTableView.reloadData()
                }
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = appTitle
        view.backgroundColor = .systemBackground
    }

    private func setupSubview() {
        let avatar = Avatar.init(frame: .zero, url: viewModel.getAvatarUrl())
        let detailLabelContainer: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.spacing = 4
            view.distribution = .fillEqually
            view.alignment = .leading
            view.isLayoutMarginsRelativeArrangement = true
            view.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            view.setContentHuggingPriority(.required, for: .horizontal)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        let nameLabel = UserDetailLabel()
        nameLabel.setText(viewModel.getUserName())
        let emailLabel = UserDetailLabel()
        emailLabel.setText(viewModel.getEmail())
        let locationLabel = UserDetailLabel()
        locationLabel.setText(viewModel.getLocation())
        let joinDateLabel = UserDetailLabel()
        joinDateLabel.setText(viewModel.getJoinDate())
        let followerLabel = UserDetailLabel()
        followerLabel.setText(viewModel.getFollowers())
        let followingLabel = UserDetailLabel()
        followingLabel.setText(viewModel.getFollowing())
        detailLabelContainer.addArrangedSubview(nameLabel)
        detailLabelContainer.addArrangedSubview(emailLabel)
        detailLabelContainer.addArrangedSubview(locationLabel)
        detailLabelContainer.addArrangedSubview(joinDateLabel)
        detailLabelContainer.addArrangedSubview(followerLabel)
        detailLabelContainer.addArrangedSubview(followingLabel)

        view.addSubview(avatar)
        view.addSubview(detailLabelContainer)

        let bioLabel: UILabel = {
            let lbl = UILabel()
            lbl.numberOfLines = 0
            lbl.lineBreakMode = .byWordWrapping
            lbl.font = UIFont(name: "HelveticaNeue", size: 13)
            lbl.textColor = .black
            lbl.textAlignment = .left
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        bioLabel.text = viewModel.getBio()
        view.addSubview(bioLabel)

        addConstraints(avatar: avatar, detailLabelContainer: detailLabelContainer, bioLabel: bioLabel)
        setupSearchBar(below: bioLabel)
        setupTableView(below: searchBar)
    }

    private func setupSearchBar(below uiview: UIView) {
        view.addSubview(searchBar)
        searchBar.delegate = self
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: uiview.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }

    private func setupTableView(below uiview: UIView) {
        view.addSubview(repoTableView)
        repoTableView.dataSource = self
        repoTableView.delegate = self
        NSLayoutConstraint.activate([
            repoTableView.topAnchor.constraint(equalTo: uiview.bottomAnchor),
            repoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            repoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            repoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func addConstraints(avatar: UIView, detailLabelContainer: UIView, bioLabel: UIView) {
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            avatar.centerYAnchor.constraint(equalTo: detailLabelContainer.centerYAnchor),
            avatar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            detailLabelContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            avatar.trailingAnchor.constraint(equalTo: detailLabelContainer.leadingAnchor, constant: -16),
            detailLabelContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            avatar.widthAnchor.constraint(equalTo: avatar.heightAnchor),

            bioLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
}

extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRepos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: repoTableCellIdentifier) else {
                return UITableViewCell(style: .value1, reuseIdentifier: repoTableCellIdentifier)
            }
            return cell
        }()
        let curRepo = filteredRepos[indexPath.row]

        cell.textLabel?.text = curRepo.name
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "\(curRepo.forkCount) Forks\n\(curRepo.starCount) Stars"
        return cell
    }
}

extension UserDetailViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchText.trimmingCharacters(in: whitespaceCharacterSet)
        if strippedString == "" {
            filteredRepos = allRepos
        } else {
            filteredRepos = allRepos.filter({ $0.name.range(of: strippedString, options: .caseInsensitive) != nil })
        }
        repoTableView.reloadData()
    }
}

extension UserDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRepo = filteredRepos[indexPath.row]
        if let url = URL(string: selectedRepo.htmlUrl) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
