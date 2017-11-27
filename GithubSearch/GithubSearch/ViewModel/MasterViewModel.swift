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

}

protocol TableCellViewModelDelegate {
    
}

class MasterViewModel: NSObject, TableViewControllerDelegate {
    
    typealias Model = RepositoryCellViewModel
    
    var delegate: TableViewModelDelegate? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    init(delegate:TableViewModelDelegate) {
        //managedObjectContext = delegate.persistentContainer.viewContext
        self.delegate = delegate
    }
    
    func item(at: IndexPath) -> TableCellViewModelDelegate? {
        return nil
    }
    
    func numberOfRows(in: Int) -> Int {
        return 1
    }
    
    
    

}
