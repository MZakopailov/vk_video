//
//  Video.swift
//  vk_video
//
//  Created by Maxim Zakopaylov on 15/05/2019.
//  Copyright © 2019 Maxim Zakopaylov. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

final class Video: Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var ownerId = 0
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
    @objc dynamic var preview = ""
    @objc dynamic var file = ""
    @objc dynamic var player = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        ownerId     <- map["owner_id"]
        title       <- map["title"]
        desc        <- map["description"]
        preview     <- map["photo_800"]
        file        <- map["files.mp4_720"]
        player      <- map["player"]
    }
}
