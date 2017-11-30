//
//  User.swift
//  GithubSearch
//
//  Created by Burak Oguz on 11/26/17.
//  Copyright © 2017 Bogus. All rights reserved.
//

import CoreData

public class User: NSManagedObject, Decodable {

    enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatarUrl = "avatar_url"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let contextInfoKey = CodingUserInfoKey.context else { fatalError() }
        guard let context = decoder.userInfo[contextInfoKey] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else { fatalError() }
        self.init(entity: entity, insertInto: context)
        
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.avatarUrl = try! container?.decodeIfPresent(String.self, forKey: CodingKeys.avatarUrl)
        self.id = (try! container?.decodeIfPresent(Int64.self, forKey: CodingKeys.id))!
        self.name = try! container?.decodeIfPresent(String.self, forKey: CodingKeys.name)
    }
    
    class func decoder() -> JSONDecoder { 
        return JSONDecoder()
    }
}
