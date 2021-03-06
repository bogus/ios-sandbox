//
//  MasterViewController.swift
//  GithubSearch
//
//  Created by Burak Oguz on 11/26/17.
//  Copyright © 2017 Bogus. All rights reserved.
//

import UIKit
import CoreData

protocol TableViewControllerDelegate {
    func item(at:IndexPath) -> TableCellViewModelDelegate?
    func numberOfRows(in:Int) -> Int
    func search(query:String?)
}

class MasterViewController: UITableViewController {

    private var detailViewController: DetailViewController? = nil
    private var viewModel:TableViewControllerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MasterViewModel(delegate:self)
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
            let _ = viewModel?.item(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                //controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(in: section) ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel?.item(at: indexPath)?.getTitle() ?? ""
        cell.detailTextLabel?.text = viewModel?.item(at: indexPath)?.getSubtitle() ?? ""
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

}

extension MasterViewController : TableViewModelDelegate {
    
    func reload() {
        tableView.reloadData()
    }
    
}

extension MasterViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.search(query: searchBar.text)
        searchBar.resignFirstResponder()
    }
    
}

