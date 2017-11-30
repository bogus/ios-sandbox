//
//  MasterViewModel.swift
//  GithubSearch
//
//  Created by Burak Oguz on 11/26/17.
//  Copyright © 2017 Bogus. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

protocol TableViewModelDelegate {
    func reload()
}

protocol TableCellViewModelDelegate {
    func getTitle() -> String
    func getSubtitle() -> String
}

class MasterViewModel: NSObject, TableViewControllerDelegate {
    
    typealias Model = RepositoryCellViewModel
    
    var delegate: TableViewModelDelegate? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var backgroundObjectContext: NSManagedObjectContext? = nil
    var repositories:[Repository]? = nil
    
    init(delegate:TableViewModelDelegate) {
        super.init()
        managedObjectContext = AppDelegate.shared.persistentContainer.viewContext
        backgroundObjectContext = AppDelegate.shared.persistentContainer.newBackgroundContext()
        self.delegate = delegate
        repositories = self.loadCached()
    }
    
    func item(at indexPath:IndexPath) -> TableCellViewModelDelegate? {
        guard let repository = repositories?[indexPath.row] else { return nil }
        return RepositoryCellViewModel(repository:repository)
    }
    
    func numberOfRows(in: Int) -> Int {
        return repositories?.count ?? 0
    }
    
    func search(query:String?) {
        guard let query = query else { return }
        Alamofire.request("https://api.github.com/search/repositories?q=" + query).response(queue: DispatchQueue.global(qos: .background)) { [weak self] response in
            if let error = response.error {
                print(error)
                return
            }
            guard let context = self?.backgroundObjectContext else { return }
            guard let data = response.data else { return }
            let repositoryRequest = try? ManagedJSONDecoder(context: context).decode(RepositoryRequest.self, from: data)
            try? context.save()
            self?.repositories = repositoryRequest?.items
            DispatchQueue.main.async {
                self?.delegate?.reload()
            }
        }
        repositories = [Repository]()
        delegate?.reload()
    }
    
    func loadCached() -> [Repository] {
        return Repository.allRepositories(context:managedObjectContext)
    }
    

}
