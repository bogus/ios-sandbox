//
//  Repository.swift
//  GithubSearch
//
//  Created by Burak Oguz on 11/26/17.
//  Copyright © 2017 Bogus. All rights reserved.
//

import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

public class Repository: NSManagedObject, Decodable {

    enum CodingKeys: String, CodingKey {
        case id
        case language
        case name
        case owner
        case fullName = "full_name"
        case lastUpdated = "updated_at"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let contextInfoKey = CodingUserInfoKey.context else { fatalError() }
        guard let context = decoder.userInfo[contextInfoKey] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "Repository", in: context) else { fatalError() }
        self.init(entity: entity, insertInto: context)
        
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.id = (try! container?.decodeIfPresent(Int64.self, forKey: CodingKeys.id))!
        self.name = try! container?.decodeIfPresent(String.self, forKey: CodingKeys.name)
        self.language = try! container?.decodeIfPresent(String.self, forKey: CodingKeys.language)
        self.lastUpdated = try! container?.decodeIfPresent(Date.self, forKey: CodingKeys.lastUpdated)
        self.fullName = try! container?.decodeIfPresent(String.self, forKey: CodingKeys.fullName)
        self.owner = try! container?.decodeIfPresent(User.self, forKey: CodingKeys.owner)
    }
    
    class func allRepositories(context: NSManagedObjectContext?) -> [Repository] {
        guard let context = context else { return [Repository]() }
        let repoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Repository")
        if let repositories = try? context.fetch(repoFetch) as? [Repository] {
            return repositories!
        }
        return [Repository]()
    }
}
