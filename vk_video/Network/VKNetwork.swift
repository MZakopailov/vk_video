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
        switch self {
        case .getVideosBy( _,  _, _):
            return "{\n  \"response\" : {\n    \"items\" : [\n      {\n        \"width\" : 1280,\n        \"title\" : \"Водонепроницаемая портативная колонка - 50k bass test (bass track)\",\n        \"can_like\" : 1,\n        \"can_add_to_faves\" : 1,\n        \"repeat\" : 1,\n        \"duration\" : 26,\n        \"first_frame_160\" : \"https:\\/\\/pp.userapi.com\\/c846420\\/v846420316\\/9eee9\\/qdIG-uJ_rk0.jpg\",\n        \"player\" : \"https:\\/\\/vk.com\\/video_ext.php?oid=-107988116&id=456239070&hash=95bf19f2d633355c&__ref=vk.api&api_hash=15580932310093963b429dd7508d_GMZTIOBWGE3Q\",\n        \"views\" : 95872,\n        \"can_comment\" : 0,\n        \"first_frame_130\" : \"https:\\/\\/pp.userapi.com\\/c846420\\/v846420316\\/9eeea\\/NdQADW9VQuc.jpg\",\n        \"photo_130\" : \"https:\\/\\/pp.userapi.com\\/c844720\\/v844720316\\/b01bb\\/szTGJJyxqmA.jpg\",\n        \"first_frame_320\" : \"https:\\/\\/pp.userapi.com\\/c846420\\/v846420316\\/9eee8\\/w9bDr1JYSfc.jpg\",\n        \"description\" : \"🔈 Беспроводная водонепроницаемая колонка 💥 ВСЕГО ЗА 1990 руб 💥 \\n‼ АКЦИЯ ТОЛЬКО 3 ДНЯ! УСПЕЙ ЗАКАЗАТЬ 👉 https:\\/\\/vk.cc\\/8j7DHz\",\n        \"height\" : 720,\n        \"is_favorite\" : false,\n        \"date\" : 1532439849,\n        \"owner_id\" : -107988116,\n        \"photo_800\" : \"https:\\/\\/pp.userapi.com\\/c844720\\/v844720316\\/b01b8\\/F25Mb7FK4po.jpg\",\n        \"can_repost\" : 1,\n        \"id\" : 456239070,\n        \"comments\" : 0,\n        \"can_add\" : 1,\n        \"first_frame_800\" : \"https:\\/\\/pp.userapi.com\\/c846420\\/v846420316\\/9eee7\\/CUwaUx59Z_0.jpg\",\n        \"photo_320\" : \"https:\\/\\/pp.userapi.com\\/c844720\\/v844720316\\/b01b9\\/rMnqMDgwlh8.jpg\"\n      }\n    ],\n    \"count\" : 74324\n  }\n}".data(using: .utf8, allowLossyConversion: false) ?? Data()
        case .getUserInfo(_):
                return Data()
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    var task: Task {
        return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.default)
    }
    
}
