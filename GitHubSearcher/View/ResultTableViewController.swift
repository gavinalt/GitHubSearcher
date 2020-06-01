//
//  ResultTableViewController.swift
//  GitHubSearcher
//
//  Created by Gavin Li on 5/31/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController {
    
    let tableViewCellIdentifier = "searcherTableCell"
    var resultUsers = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearcherTableCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.rowHeight = 64
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! SearcherTableCell
        let curUser = resultUsers[indexPath.row]

        cell.configureCell(basedOn: curUser)
        return cell
    }
}
