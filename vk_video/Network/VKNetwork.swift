//
//  VKNetwork.swift
//  vk_video
//
//  Created by Maxim Zakopaylov on 14/05/2019.
//  Copyright © 2019 Maxim Zakopaylov. All rights reserved.
//

import Foundation
import Moya

enum VKApiProvider: TargetType {
    case getUserInfo(token: String)

    var baseURL: URL {
        return URL(string: "https://api.vk.com/method")!
    }

    var path: String {
        switch self {
        case .getUserInfo:
            return "/users.get"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getUserInfo(let token):
            return ["access_token": token, "v": "5.95", "fields": "photo_max_orig"]
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
