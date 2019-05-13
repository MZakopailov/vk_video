//
//  User.swift
//  vk_video
//
//  Created by Maxim Zakopaylov on 13/05/2019.
//  Copyright © 2019 Maxim Zakopaylov. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

final class User: Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var token = ""
    @objc dynamic var name = ""
    @objc dynamic var avatar = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id      <- map["id"]
        token   <- map["key"]
        name    <- map["name"]
        avatar  <- map["avatar"]
    }
 
    static func saveUser(_ user: User) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(user, update: true)
        }
    }
}
