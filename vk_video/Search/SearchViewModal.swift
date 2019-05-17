//
//  SearchViewModal.swift
//  vk_video
//
//  Created by Maxim Zakopaylov on 13/05/2019.
//  Copyright © 2019 Maxim Zakopaylov. All rights reserved.
//

import Foundation
import RxSwift
import VK_ios_sdk
import RealmSwift
import RxRealm
import Moya
import SwiftyJSON
import Moya_ObjectMapper

struct SearchViewModel {
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var provider: MoyaProvider<VKApiProvider>! = MoyaProvider<VKApiProvider>()
    
    func searchVideo(query: String, count: Int = 20, offset: Int = 0) -> Observable<[Video]> {
        return provider
            .rx
            .request(.getVideosBy(query: query, count: count, offset: offset))
            .mapArray(Video.self, atKeyPath: "response.items", context: nil)
            .asObservable()
    }
}
