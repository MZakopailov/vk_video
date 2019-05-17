//
//  vk_VKNetworkTest.swift
//  vk_videoTests
//
//  Created by Maxim Zakopaylov on 17/05/2019.
//  Copyright © 2019 Maxim Zakopaylov. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import Moya

@testable import vk_video

class vk_VKNetworkTest: QuickSpec {
    
    override func spec() {
        var testProvider: MoyaProvider<VKApiProvider>!
        let disposeBag = DisposeBag()
        
        beforeSuite {
            testProvider = MoyaProvider<VKApiProvider>(stubClosure: MoyaProvider.immediatelyStub)
        }
        
        describe("testProvider") {
            it("should be not nil") {
                expect(testProvider).toNot(beNil())
            }
        }
        
        describe("getVideos") {
            it("should return not nil videos object") {
                testProvider
                    .rx
                    .request(.getVideosBy(query: "test", count: 1, offset: 0))
                    .mapArray(Video.self, atKeyPath: "response.items", context: nil)
                    .subscribe(onSuccess: { (videos) in
                        expect(videos).toNot(beNil())
                    }).disposed(by: disposeBag)
            }
        }
    }

}
