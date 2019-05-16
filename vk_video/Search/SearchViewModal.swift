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

struct SearchViewModel {
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var provider: MoyaProvider<VKApiProvider>! = MoyaProvider<VKApiProvider>()
    
    func searchVideo(query: String, count: Int = 20, offset: Int = 0) -> Observable<[Video]> {
        return provider.rx.request(.getVideosBy(query: query, count: count, offset: offset)).asObservable().map({ (response) -> [Video] in
            guard let json = try? JSON(data: response.data) else { return [] }
            guard let jsonObj = json["response"]["items"].array else { return [] }
            var videos = [Video]()
            jsonObj.forEach({ (j) in
                if let v = Video(JSONString: j.description), v.player != "" {
                    videos.append(v)
                }
            })
            return videos
        })
    }
}
