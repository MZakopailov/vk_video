//
//  VKNetwork.swift
//  vk_video
//
//  Created by Maxim Zakopaylov on 14/05/2019.
//  Copyright © 2019 Maxim Zakopaylov. All rights reserved.
//

import Foundation
import Moya
import RealmSwift

enum VKApiProvider: TargetType {
    case getUserInfo(token: String)
    case getVideosBy(query: String, count: Int, offset: Int)

    var baseURL: URL {
        return URL(string: "https://api.vk.com/method")!
    }
    
    var userToken: String {
        let realm = try! Realm(configuration: CONFIG_REALM)
        return realm.objects(User.self).last?.token ?? ""
    }

    var path: String {
        switch self {
        case .getUserInfo:
            return "/users.get"
        case .getVideosBy:
            return "/video.search"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getUserInfo(let token):
            return ["access_token": token, "v": "5.95", "fields": "photo_max_orig"]
        case .getVideosBy(let query, let count, let offset):
            return ["access_token": self.userToken, "v": "5.95", "hd": 1, "q": query, "offset": offset, "count": count]
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    var task: Task {
        return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.default)
    }
    
}
