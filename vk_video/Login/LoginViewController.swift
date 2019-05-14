//
//  ViewController.swift
//  vk_video
//
//  Created by Maxim Zakopaylov on 13/05/2019.
//  Copyright © 2019 Maxim Zakopaylov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import VK_ios_sdk

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    
    lazy var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.sdkInstance.uiDelegate = self
        viewModel.sdkInstance.register(self)
        
        self.loginBtn
            .rx
            .tap
            .asDriver()
            .debounce(0.25)
            .drive(onNext: { [weak self] in
               self?.loginAct()
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    func loginAct() {
        VKSdk.forceLogout()
        VKSdk.authorize(["video"])
    }
    
    func showSearch() {
        let storyboard = UIStoryboard(name: "search", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() else { return }
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}


extension LoginViewController: VKSdkDelegate, VKSdkUIDelegate {
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.state != .error {
            guard let r = result else { return }
            self.viewModel.loadUserInfo(token: r.token.accessToken).subscribe { [weak self] (status) in
                guard let strongSelf = self else { return }
                if status.element == true {
                    strongSelf.showSearch()
                }
            }.disposed(by: viewModel.disposeBag)
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("VK error autorizations")
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        let captchaVK = VKCaptchaViewController.captchaControllerWithError(captchaError)
        self.present(captchaVK!, animated: true, completion: nil)
    }
    
    func vkSdkWillDismiss(_ controller: UIViewController!) {
        print("dismis VK SDK!")
    }
}
