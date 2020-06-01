import UIKit

class SearcherViewController: UIViewController {

    let appTitle = "GitHub Searcher"
    let searchFieldPlaceHolder = "Search for Users"
    let tableViewCellIdentifier = "searcherTableCell"
    let queryService = QueryService.init()

    var searchController: UISearchController!
    private var resultTableController: ResultTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = appTitle
        view.backgroundColor = .systemBackground
        setupSearchController()
    }
    
    private func setupSearchController() {
        resultTableController = ResultTableViewController.init()
        resultTableController.tableView.delegate = self

        searchController = UISearchController(searchResultsController: resultTableController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = searchFieldPlaceHolder

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }

}

extension SearcherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = resultTableController.resultUsers[indexPath.row]

        let detailViewController = UserDetailViewController.init(userId: selectedUser.userId)
        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension SearcherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}

extension SearcherViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)

        queryService.getSearchResults(searchTerm: strippedString) { (queryResponse, errorMsg) in
            DispatchQueue.main.async {
                if errorMsg != "" {
                    //                print(errorMsg)
                }

                if let response = queryResponse,
                    let resultsController = searchController.searchResultsController as? ResultTableViewController {
                    resultsController.resultUsers = response.users
                    resultsController.tableView.reloadData()
                }
            }
        }
    }
}

extension SearcherViewController: UISearchControllerDelegate {

}
