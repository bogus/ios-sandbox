//
//  RepositoryCellViewModel.swift
//  GithubSearch
//
//  Created by Burak Oguz on 11/26/17.
//  Copyright © 2017 Bogus. All rights reserved.
//

import UIKit

class RepositoryCellViewModel: TableCellViewModelDelegate {
    
    var repository:Repository? = nil
    
    init(repository:Repository) {
        self.repository = repository
    }
    
    func getTitle() -> String {
        return repository?.fullName ?? "No repo"
    }
    
    func getSubtitle() -> String {
        return repository?.owner?.name ?? "No owner"
    }
    
}
