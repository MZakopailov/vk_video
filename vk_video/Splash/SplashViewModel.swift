//
//  SplashViewModel.swift
//  vk_video
//
//  Created by Maxim Zakopaylov on 13/05/2019.
//  Copyright © 2019 Maxim Zakopaylov. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

struct SplashViewModel {
 
    var isLogin: Bool {
        let realm = try! Realm(configuration: CONFIG_REALM)
        let users = realm.objects(User.self)
        return users.first(where: {$0.token != "" }) != nil
    }
    
}
