//
//  SplashViewController.swift
//  vk_video
//
//  Created by Maxim Zakopaylov on 13/05/2019.
//  Copyright © 2019 Maxim Zakopaylov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SplashViewController: UIViewController {

    lazy var viewModel = SplashViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.routeVCisLogin(viewModel.isLogin)
    }
    
    func routeVCisLogin(_ status: Bool) {
        let nameStoryBoard = status ? "search" : "login"
        let storyboard = UIStoryboard(name: nameStoryBoard, bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() else { return }
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
}
