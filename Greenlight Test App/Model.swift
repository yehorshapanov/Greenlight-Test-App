//
//  Model.swift
//  Greenlight Test App
//
//  Created by Yehor Shapanov on 11/14/18.
//  Copyright © 2018 Yehor Shapanov. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

protocol API {
    static func url() -> String
}

final class Repo: Object,Mappable,API {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var issuesCount = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["full_name"]
        issuesCount <- map["open_issues_count"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func url() -> String {
        return "https://api.github.com/orgs/realm/repos"
    }
}
