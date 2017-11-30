//
//  MasterViewModel.swift
//  GithubSearch
//
//  Created by Burak Oguz on 11/26/17.
//  Copyright © 2017 Bogus. All rights reserved.
//

import UIKit
import CoreData

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
        guard let query = query,
            let url = URL(string:"https://api.github.com/search/repositories?q=" + query) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context!] = self.backgroundObjectContext
            decoder.dateDecodingStrategy = .iso8601
            guard let data = data else { return }
            let repositoryRequest = try? decoder.decode(RepositoryRequest.self, from: data)
            try? self.backgroundObjectContext?.save()
            self.repositories = repositoryRequest?.items
            DispatchQueue.main.async {
                self.delegate?.reload()
            }
        }
        task.resume()
        repositories = [Repository]()
        delegate?.reload()
    }
    
    func loadCached() -> [Repository] {
        return Repository.allRepositories(context:managedObjectContext)
    }
    

}
