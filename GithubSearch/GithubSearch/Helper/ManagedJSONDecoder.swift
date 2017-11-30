//
//  ManagedJSONDecoder.swift
//  GithubSearch
//
//  Created by Burak Oguz on 11/29/17.
//  Copyright © 2017 Bogus. All rights reserved.
//

import CoreData

class ManagedJSONDecoder: JSONDecoder {

    init(context:NSManagedObjectContext) {
        super.init()
        userInfo[CodingUserInfoKey.context!] = context
        dateDecodingStrategy = .iso8601
    }
    
}
