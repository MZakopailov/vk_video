//
//  LoginViewModel.swift
//  vk_video
//
//  Created by Maxim Zakopaylov on 14/05/2019.
//  Copyright © 2019 Maxim Zakopaylov. All rights reserved.
//

import Foundation
import RxSwift
import VK_ios_sdk
import RealmSwift
import RxRealm
import Moya
import SwiftyJSON

struct LoginViewModel {
    
    let sdkInstance: VKSdk = VKSdk.initialize(withAppId: "6982142")
    let disposeBag: DisposeBag = DisposeBag()

    var provider:MoyaProvider<VKApiProvider>! = MoyaProvider<VKApiProvider>()
    
    func loadUserInfo(token: String) -> Observable<Bool> {
        return provider.rx.request(.getUserInfo(token: token)).asObservable().map { (response) -> Bool in
            guard let json = try? JSON(data: response.data) else { return false }
            guard let jsonObj = json["response"].array else { return false }
            guard let user = User(JSONString: jsonObj.first?.description ?? "") else { return false }
            self.saveUser(user, token: token)
            return true
        }
    }
    
    func saveUser(_ user: User, token: String) {
        user.token = token
        let realm = try! Realm(configuration: CONFIG_REALM)
        try? realm.write {
            realm.add(user, update: true)
        }
    }
}
